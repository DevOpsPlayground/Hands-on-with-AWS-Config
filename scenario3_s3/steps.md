# Lambda

Firstly, we will create a Lambda function which will be triggered via CloudWatch event, which we will create later. The lambda function will examine an S3 bucket which has been passed in from the event.

It will check which areas of the bucket's configuration are non-compliant, and remediate this automatically.

## Create Function

We'll start by creating the custom rule Lambda function. Head to https://eu-west-1.console.aws.amazon.com/lambda/home?region=eu-west-1# in your browser.

Click "Create function"

Under function name, enter the following, replacing <USER> with your user number: dpg-user<USER>-remediate-s3 
Runtime - select: Python3.6

Click "Choose or create an execution role" under "Permissions" to expand the field.

Click "Use an existing role"

Select "lambda-dpgconfig".

Click "Create function"

## Deploy Code

Copy code from lambda_function.py

Scroll down to the "Environment Variables" section and add the following (we do this as we only want to remediate our own buckets, which have been tagged):
DPGUser = user<USER>


Click Save at the top of the screen





# AWS CloudWatch

Head to https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#rules:action=create

Click "Edit" by "Event Pattern Preview".

Enter contents of cloudwatch_event.json

Click Save

Under "Targets" click "Add target"

Next to "Function" click "Select Function" and choose the Lambda function you created earlier 

Click "Configure details"

Name the rule (replacing <USER> with your user number) "dpg-user<USER>-event-rule-s3"


# AWS Config

Pre-requisites:

* Lambda Created
* Event Created
* 


## Create Rule

Head to https://eu-west-1.console.aws.amazon.com/config/home?region=eu-west-1#/rules/select-rule

Search for "s3-bucket-public-read-prohibited" and click on the item.

Change the Rule Name to (replacing <USER> with your user number): dpg-config-<USER>-s3-non-compliant

Scroll down and click "Save"

## Test the Rule

Head over to S3 https://s3.console.aws.amazon.com/s3/home?region=eu-west-1#

There is already an S3 bucket created for you, named dpg-config-user<USER>-s3-bucket (replacing <USER> with your user number)

Click on the bucket.

Click Permissions

Click "Access Control List"

Scroll down to "Public access"

Click the circle next to "Everyone"

Check the boxes next to "List objects" and "Read bucket permissions" and click "Save".

Public read access is now granted to your bucket. In a new tab, head back to your Config Rule to evaluate the compliance of your bucket.

Click the "Reevaluate" button on the Rule page.

Once the Noncompliant bucket is noted, an event will be generated in CloudWatch and sent to the Lambda function you created.

Refresh the bucket page until the public access has been automatically revoked.