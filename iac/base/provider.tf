provider "aws" {
  region = local.aws_region
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Env       = terraform.workspace
      Repo      = path.module
    }
  }
}
