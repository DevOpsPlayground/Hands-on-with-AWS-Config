data "aws_iam_policy_document" "dpg_lambda_policy_document" {
  statement {
    actions = [
      "s3:PutAccountPublicAccessBlock",
      "s3:GetAccountPublicAccessBlock",
      "s3:ListAllMyBuckets",
      "s3:ListJobs",
      "s3:CreateJob",
      "s3:HeadBucket",
      "s3:GetBucketTagging",
      "s3:PutBucketAcl",
    ]

    resources = [
      "${aws_s3_bucket.b.arn}",
    ]
  }

  statement {
    actions = [
      "logs:*",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}
