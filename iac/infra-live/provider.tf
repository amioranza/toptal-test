provider "aws" {
  region = local.aws_region
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Changed   = timestamp()
      Env       = terraform.workspace
      Layer     = basename(path.cwd)
      Dummy     = "2"
    }
  }
}
