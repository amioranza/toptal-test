terraform {
  backend "s3" {
    region               = "us-east-1"
    bucket               = "tt-take-home-test-terraform-state"
    key                  = "terraform.tfstate"
    dynamodb_table       = "tt-take-home-test-terraform-state-lock"
    workspace_key_prefix = "base"
    encrypt              = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.45.0"
    }
  }
}
