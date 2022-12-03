locals {
  env             = terraform.workspace
  azs             = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]

  # AWS VPC
  aws_azs                = var.aws_azs != null ? var.aws_azs : local.azs
  aws_private_subnets    = var.aws_private_subnets != null ? var.aws_private_subnets : local.private_subnets
  aws_public_subnets     = var.aws_public_subnets != null ? var.aws_public_subnets : local.public_subnets
  aws_region             = var.aws_region != "" ? var.aws_region : "us-east-1"
  aws_single_nat_gateway = var.aws_single_nat_gateway ? var.aws_single_nat_gateway : true
  aws_vpc_cidr           = var.aws_vpc_cidr != "" ? var.aws_vpc_cidr : "10.1.0.0/16"
  aws_vpc_name           = var.aws_vpc_name != "" ? var.aws_vpc_name : "application-vpc"

  # ECS CLUSTER
}
