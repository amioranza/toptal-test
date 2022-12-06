resource "aws_ecs_service" "web" {
  name            = "web"
  cluster         = data.aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group_web.arn
    container_name   = "web"
    container_port   = 3000
  }

  network_configuration {
    security_groups  = ["${aws_security_group.web_security_group.id}"]
    subnets          = data.aws_subnets.private.ids
    assign_public_ip = false
  }
  force_new_deployment = true
}

resource "aws_security_group" "web_security_group" {
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

resource "aws_ecs_task_definition" "web" {
  family                   = "web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = module.web.json_map_encoded_list
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_execution_role.arn
}

module "web" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.1"

  container_name   = "web"
  container_image  = "${data.aws_ecr_repository.web.repository_url}:${data.aws_ssm_parameter.web_docker_tag.value}"
  container_memory = 128
  port_mappings = [{
    containerPort = 3000
    hostPort      = 3000
    protocol      = "TCP"
  }]
  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-group"         = aws_cloudwatch_log_group.logs["web"].name
      "awslogs-region"        = local.aws_region
      "awslogs-stream-prefix" = "web"
    }
  }
  map_environment = {
    "PORT"     = "3000"
    "API_HOST" = "http://${aws_alb.application_load_balancer.dns_name}"
  }
}
