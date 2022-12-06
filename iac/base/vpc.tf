module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name               = local.aws_vpc_name
  cidr               = local.aws_vpc_cidr
  azs                = local.aws_azs
  private_subnets    = local.aws_private_subnets
  public_subnets     = local.aws_public_subnets
  single_nat_gateway = local.aws_single_nat_gateway
  enable_nat_gateway = true

}
