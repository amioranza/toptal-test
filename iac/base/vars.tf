variable "aws_azs" {
  default = null
}

variable "aws_private_subnets" {
  default = null
}

variable "aws_public_subnets" {
  default = null
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_single_nat_gateway" {
  default = true
}

variable "aws_vpc_cidr" {
  default = ""
}

variable "aws_vpc_name" {
  default = ""
}
