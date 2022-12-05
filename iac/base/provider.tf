provider "aws" {
  region = local.aws_region
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Env       = terraform.workspace
      Layer     = basename(path.cwd)
    }
  }
}
