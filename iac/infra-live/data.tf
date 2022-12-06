data "aws_caller_identity" "current" {}

data "aws_elb_service_account" "default" {}

data "aws_ecs_cluster" "ecs-cluster" {
  cluster_name = "tt-cluster-${local.env}"
}

data "aws_ecs_task_definition" "api" {
  task_definition = aws_ecs_task_definition.api.family
}

data "aws_ecr_repository" "api" {
  name = "api"
}

data "aws_ecr_repository" "web" {
  name = "web"
}

data "aws_vpc" "application_vpc" {
  filter {
    name   = "tag-value"
    values = ["application-vpc-${local.env}"]
  }
  filter {
    name   = "tag-key"
    values = ["Name"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.application_vpc.id]
  }
  tags = {
    Name = "application-vpc-${local.env}-private-*"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.application_vpc.id]
  }
  tags = {
    Name = "application-vpc-${local.env}-public-*"
  }
}

data "aws_ssm_parameter" "api_docker_tag" {
  name = "/application/api/${local.env}/docker_tag"
}

data "aws_ssm_parameter" "web_docker_tag" {
  name = "/application/web/${local.env}/docker_tag"
}

data "aws_ssm_parameter" "database_password" {
  name = "/application/global/${local.env}/database_password"
}

data "aws_db_instance" "database" {
  db_instance_identifier = "tt-${local.env}-app"
}

data "aws_cloudfront_cache_policy" "no_cache" {
  name = "Managed-CachingDisabled"
}
