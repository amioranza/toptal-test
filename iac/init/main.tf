module "terraform_state_backend" {
  source     = "cloudposse/tfstate-backend/aws"
  version    = "1.5.0"
  namespace  = "tt"
  stage      = "take-home-test"
  name       = "terraform"
  attributes = ["state"]
}
