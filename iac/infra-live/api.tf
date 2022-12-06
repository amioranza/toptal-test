resource "aws_ecs_service" "api" {
  name            = "api"
  cluster         = data.aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group_api.arn
    container_name   = "api"
    container_port   = 3000
  }
  network_configuration {
    security_groups  = ["${aws_security_group.api_security_group.id}"]
    subnets          = data.aws_subnets.private.ids
    assign_public_ip = false
  }
  force_new_deployment = true
}

resource "aws_security_group" "api_security_group" {
  vpc_id = data.aws_vpc.application_vpc.id
  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "TCP"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
    containerPort = 3000
    hostPort      = 3000
    protocol      = "TCP"
  }]
  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-group"         = aws_cloudwatch_log_group.logs["api"].name
      "awslogs-region"        = local.aws_region
      "awslogs-stream-prefix" = "api"
    }
  }
  map_environment = {
    "PORT"   = "3000"
    "DB"     = data.aws_db_instance.database.db_name
    "DBUSER" = data.aws_db_instance.database.master_username
    "DBHOST" = data.aws_db_instance.database.address
    "DBPORT" = data.aws_db_instance.database.port
  }
  map_secrets = {
    "DBPASS" = data.aws_ssm_parameter.database_password.arn
  }
}
