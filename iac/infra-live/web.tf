resource "aws_ecs_service" "web" {
  name            = "web"
  cluster         = data.aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnets.private.ids
    assign_public_ip = false
  }
  force_new_deployment = true
}

resource "aws_ecs_task_definition" "web" {
  family                   = "web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = module.api.json_map_encoded_list
}

module "web" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.1"

  container_name   = "web"
  container_image  = "${data.aws_ecr_repository.api.repository_url}:"
  container_memory = 128
  port_mappings = [{
    containerPort = 8080
    hostPort      = 8080
    protocol      = "TCP"
  }]
}
