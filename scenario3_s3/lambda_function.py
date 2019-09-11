import boto3
from botocore.exceptions import ClientError
import json
import os

ACL_RD_WARNING = "The S3 bucket ACL allows public read access."
PLCY_RD_WARNING = "The S3 bucket policy allows public read access."
ACL_WRT_WARNING = "The S3 bucket ACL allows public write access."
PLCY_WRT_WARNING = "The S3 bucket policy allows public write access."
RD_COMBO_WARNING = ACL_RD_WARNING + PLCY_RD_WARNING
WRT_COMBO_WARNING = ACL_WRT_WARNING + PLCY_WRT_WARNING


def policyNotifier(bucketName, s3client):
    try:
        bucketPolicy = s3client.get_bucket_policy(Bucket=bucketName)
        # notify that the bucket policy may need to be reviewed due to security concerns
        sns = boto3.client('sns')
        subject = os.environ['PLAYGROUND_USER'] + \
            " - Potential compliance violation in " + bucketName + " bucket policy"
        message = "Potential bucket policy compliance violation. Please review: " + \
            json.dumps(bucketPolicy['Policy'])
        # send SNS message with warning and bucket policy
        response = sns.publish(
            TopicArn=os.environ['TOPIC_ARN'],
            Subject=subject,
            Message=message
        )
        print(response)
    except ClientError as e:
        # error caught due to no bucket policy
        print("No bucket policy found; no alert sent.")
        print(e)


def lambda_handler(event, context):
    # instantiate Amazon S3 client
    print(event)
    s3 = boto3.client('s3')

    resource = list(event['detail']['requestParameters']['evaluations'])[0]
    bucketName = resource['complianceResourceId']

    bucket_tagging = s3.get_bucket_tagging(
        Bucket=bucketName
    )
    print(bucket_tagging)
    for tag in bucket_tagging['TagSet']:
        if (tag['Key'] == 'DPGS3User') and (tag['Value'] == os.environ['PLAYGROUND_USER']):

            complianceFailure = event['detail']['requestParameters']['evaluations'][0]['annotation']
            if(complianceFailure == ACL_RD_WARNING or complianceFailure == ACL_WRT_WARNING):
                s3.put_bucket_acl(Bucket=bucketName, ACL='private')
                print("Putting private ACL")
            elif(complianceFailure == PLCY_RD_WARNING or complianceFailure == PLCY_WRT_WARNING):
                #policyNotifier(bucketName, s3)
                print("No action required")
            elif(complianceFailure == RD_COMBO_WARNING or complianceFailure == WRT_COMBO_WARNING):
                s3.put_bucket_acl(Bucket=bucketName, ACL='private')
                #policyNotifier(bucketName, s3)
                print("Putting private ACL")
            break

    return 0  # done
