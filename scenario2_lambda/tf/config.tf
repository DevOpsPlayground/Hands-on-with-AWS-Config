resource "aws_config_config_rule" "rule" {
  name = "dpg-${var.DPG_USER}-rule-lambda"

  scope = {
    compliance_resource_types = ["AWS::Lambda::Function"]
  }

  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = "${aws_lambda_function.lambda_function.arn}"

    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }
}
