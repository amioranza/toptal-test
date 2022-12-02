module "terraform_state_backend" {
  source     = "cloudposse/tfstate-backend/aws"
  version    = "0.38.1"
  namespace  = "tt"
  stage      = "take-home-test"
  name       = "terraform"
  attributes = ["state"]
}
