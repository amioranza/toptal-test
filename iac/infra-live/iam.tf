resource "aws_iam_role_policy" "task_execution_policy" {
  name   = "task-execution-role-policy-${local.env}"
  role   = aws_iam_role.task_execution_role.name
  policy = data.aws_iam_policy_document.ecs_task_execution_policy_document.json
}

resource "aws_iam_role_policy" "execution_policy" {
  name   = "execution-role-policy-${local.env}"
  role   = aws_iam_role.task_execution_role.name
  policy = data.aws_iam_policy_document.ecs_task_execution_policy_document.json
}


resource "aws_iam_role" "task_execution_role" {
  name               = "task-role-${local.env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "task_execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "task_execution_role_policy_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = data.aws_iam_policy.task_execution_policy.arn
}

data "aws_iam_policy_document" "ecs_task_execution_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]

    resources = [
      "arn:aws:ssm:${local.aws_region}:${local.aws_account_id}:parameter/application/*/${local.env}/*",
      "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:*",
      "arn:aws:kms:${local.aws_region}:${local.aws_account_id}:key/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecs:RegisterContainerInstance",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Submit*",
      "ecs:Poll",
      "ecs:StartTask",
      "ecs:StartTelemetrySession"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:Create*",
      "logs:Put*",
      "logs:Get*",
      "logs:Update*",
      "logs:Describe*",
      "logs:List*",
      "logs:Tag*",
      "logs:Filter*"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"
    sid    = "ECR"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]

    resources = ["*"]
  }

  statement {
    sid     = "ECRGetAuthorizationToken"
    effect  = "Allow"
    actions = ["ecr:GetAuthorizationToken"]

    resources = ["*"]
  }

}

data "aws_iam_policy_document" "resource" {
  statement {
    sid    = "ecr"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.task_execution_role.arn
      ]
    }
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
    ]
  }
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  for_each   = toset(local.app_modules)
  repository = each.value
  policy     = data.aws_iam_policy_document.resource.json
}
