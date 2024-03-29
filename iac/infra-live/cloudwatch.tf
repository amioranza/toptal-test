resource "aws_cloudwatch_log_group" "logs" {
  for_each          = toset(local.app_modules)
  name              = "/application/${each.value}/${local.env}"
  retention_in_days = 120
}
