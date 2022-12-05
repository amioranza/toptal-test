module "ecs_cluster" {
  source  = "cloudposse/ecs-cluster/aws"
  version = "0.2.3"

  namespace = "tt"
  name      = "cluster-${local.env}"

  container_insights_enabled      = true
  capacity_providers_fargate      = true
  capacity_providers_fargate_spot = true
}
