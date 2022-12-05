data "aws_caller_identity" "current" {}

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
    Name = "application-vpc-development-private-*"
  }
}

data "aws_ssm_paramter" "api_docker_tag" {
  name = "/application/api/${local.env}/docker_tag"
}

data "aws_ssm_paramter" "web_docker_tag" {
  name = "/application/web/${local.env}/docker_tag"
}
