resource "aws_cloudwatch_log_group" "esc" {
  name = "${var.application_name}-log"

  retention_in_days = 7

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}
