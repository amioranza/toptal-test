resource "aws_ssm_parameter" "ssm-parameters" {
  for_each = {
    api_docker_tag    = "/application/api/${local.env}/api_docker_tag"
    web_docker_tag    = "/application/api/${local.env}/web_docker_tag"
    database_password = "/application/global/${local.env}/database_password"
  }
  lifecycle {
    ignore_changes = [
      value
    ]
  }
  name  = each.value
  type  = "SecureString"
  value = "changeme"
}
