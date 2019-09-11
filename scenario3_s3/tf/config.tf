resource "aws_config_config_rule" "r" {
  name = "dpg-${var.DPG_USER}-rule-s3"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  scope = {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }
}
