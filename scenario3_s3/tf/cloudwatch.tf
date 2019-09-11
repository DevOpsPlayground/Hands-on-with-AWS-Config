resource "aws_cloudwatch_event_rule" "non-compliant-s3-bucket" {
  name        = "dpg-${var.DPG_USER}-non-compliant-s3-bucket"
  description = "Triggered when an S3 bucket is evaluated as publicly accessible (non-compliant) on AWS Config"

  event_pattern = <<PATTERN
{
    "source": [
        "aws.config"
    ],
    "detail": {
        "requestParameters": {
            "evaluations": {
                "complianceType": [
                    "NON_COMPLIANT"
                ]
            }
        },
        "additionalEventData": {
            "managedRuleIdentifier": [
                "S3_BUCKET_PUBLIC_READ_PROHIBITED",
                "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
            ]
        }
    }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = "${aws_cloudwatch_event_rule.non-compliant-s3-bucket.name}"
  target_id = "dpg-remediate-s3"
  arn       = "${aws_lambda_function.lambda_function.arn}"
}
