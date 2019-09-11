resource "aws_config_config_rule" "rule" {
  name        = "dpg-${var.DPG_USER}-rule-ec2"
  description = "Checks whether your EC2 instances are of the specified instance types."

  source {
    owner             = "AWS"
    source_identifier = "DESIRED_INSTANCE_TYPE"
  }

  scope = {
    tag_key   = "DPGEC2User"
    tag_value = "${var.DPG_USER}"
  }

  input_parameters = "{\"instanceType\": \"t2.small\"}"
}
