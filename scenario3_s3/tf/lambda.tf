resource "aws_lambda_permission" "lambda_source" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_function.arn}"
  principal     = "events.amazonaws.com"
  statement_id  = "AllowExecutionFromCloudWatch"
  source_arn    = "${aws_cloudwatch_event_rule.non-compliant-s3-bucket.arn}"
}

resource "aws_lambda_function" "lambda_function" {
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.6"
  filename         = "lambda.zip"
  function_name    = "dpg-${var.DPG_USER}-remediate-public-s3"
  source_code_hash = "${base64sha256(file("lambda.zip"))}"

  environment {
    variables = {
      "PLAYGROUND_USER" = "${var.DPG_USER}"
      "TOPIC_ARN"       = "${aws_sns_topic.alerts-topic.arn}"
    }
  }
}
