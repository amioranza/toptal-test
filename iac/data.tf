data "aws_key_pair" "example" {
  include_public_key = true

  filter {
    name   = "tag:purpose"
    values = ["tests"]
  }
}
