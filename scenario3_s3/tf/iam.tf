resource "aws_iam_policy" "dpg_lambda_policy_document" {
  name   = "dpg-${var.DPG_USER}-policy-s3-remediation"
  path   = "/"
  policy = "${data.aws_iam_policy_document.dpg_lambda_policy_document.json}"
}

resource "aws_iam_policy_attachment" "lambda-attachment-s3-remediation" {
  name = "dpg-${var.DPG_USER}-lambda-attachment-s3-remediation"

  roles      = ["${aws_iam_role.lambda_exec_role.name}"]
  policy_arn = "${aws_iam_policy.dpg_lambda_policy_document.arn}"
  depends_on = ["aws_iam_policy.dpg_lambda_policy_document"]
}

resource "aws_iam_role" "lambda_exec_role" {
  name        = "dpg-${var.DPG_USER}-lambda-exec-s3-remediation"
  path        = "/"
  description = "Allows Lambda Function to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
