resource "aws_alb" "application_load_balancer" {
  name               = "tt-alb-${local.env}"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.private.ids
  security_groups    = ["${aws_security_group.load_balancer_security_group.id}"]

  # access_logs {
  #   bucket  = aws_s3_bucket.alb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }
}

# S3 bucket only for ALB logs
# resource "aws_s3_bucket" "alb_logs" {
#   bucket = "tt-alb-logs-${local.env}"
# }

# resource "aws_s3_bucket_acl" "alb_logs" {
#   bucket = aws_s3_bucket.alb_logs.id
#   acl    = "log-delivery-write"
# }

# Creating a security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = data.aws_vpc.application_vpc.id
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "target_group_web" {
  name        = "target-group-web-${local.env}"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.application_vpc.id
  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
}

resource "aws_lb_target_group" "target_group_api" {
  name        = "target-group-api-${local.env}"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.application_vpc.id
  health_check {
    matcher = "200"
    path    = "/api/status"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_web.arn
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_api.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }

}
