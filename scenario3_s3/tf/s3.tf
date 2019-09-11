resource "aws_s3_bucket" "b" {
  bucket = "dpg-${var.DPG_USER}-s3-bucket"
  acl    = "private"

  tags = {
    DPGS3User = "${var.DPG_USER}"
  }
}
