resource "aws_sns_topic" "alerts-topic" {
  name = "dpg-${var.DPG_USER}-alerts-topic"
}
