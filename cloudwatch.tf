resource "aws_cloudwatch_event_rule" "non-compliant-s3-bucket" {
  name        = "dpg-$[var.DPG_USER}-non-compliant-s3-bucket"
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

resource "aws_cloudwatch_event_target" "sns" {
  rule      = "${aws_cloudwatch_event_rule.console.name}"
  target_id = "SendToSNS"
  arn       = "${aws_sns_topic.aws_logins.arn}"
}

resource "aws_sns_topic" "aws_logins" {
  name = "aws-console-logins"
}

resource "aws_sns_topic_policy" "default" {
  arn    = "${aws_sns_topic.aws_logins.arn}"
  policy = "${data.aws_iam_policy_document.sns_topic_policy.json}"
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = ["${aws_sns_topic.aws_logins.arn}"]
  }
}
