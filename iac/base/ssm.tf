resource "aws_ssm_parameter" "ssm-parameters" {
  # create SSM paramters to use during deploys
  for_each = {
    api_docker_tag    = "/application/api/${local.env}/docker_tag"
    web_docker_tag    = "/application/web/${local.env}/docker_tag"
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
