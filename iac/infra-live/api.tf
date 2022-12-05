resource "aws_ecs_service" "api" {
  name            = "api"
  cluster         = data.aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnets.private.ids
    assign_public_ip = false
  }
  # iam_role             = aws_iam_role.task_execution_role.arn
  # depends_on           = [aws_iam_role.task_execution_role]
  force_new_deployment = true
}

resource "aws_ecs_task_definition" "api" {
  family                   = "api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = module.api.json_map_encoded_list
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_execution_role.arn
}

module "api" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.1"

  container_name   = "api"
  container_image  = "${data.aws_ecr_repository.api.repository_url}:${data.aws_ssm_parameter.api_docker_tag.value}"
  container_memory = 128
  port_mappings = [{
    containerPort = 8080
    hostPort      = 8080
    protocol      = "TCP"
  }]
  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-group"         = aws_cloudwatch_log_group.logs["api"].name
      "awslogs-region"        = local.env
      "awslogs-create-group"  = "true",
      "awslogs-stream-prefix" = "api"
    }
  }
}
