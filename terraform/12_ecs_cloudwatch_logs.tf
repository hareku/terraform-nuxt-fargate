#####################################
# CloudWatch Logs for ECS Settings
#####################################
resource "aws_cloudwatch_log_group" "application" {
  name = "application/${local.app_name}"
}
