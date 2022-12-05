locals {
  env            = terraform.workspace
  app_modules    = ["api", "web"]
  aws_region     = "us-east-1"
  aws_account_id = data.aws_caller_identity.current.account_id
}
