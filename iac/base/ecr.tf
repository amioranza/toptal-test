# cannot use use count and for_each in the same block
# had to duplicate the block for each module
resource "aws_ecr_repository" "api" {
  # avoid creating one ecr per env
  count                = local.env == "development" ? 1 : 0
  name                 = "api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "web" {
  # avoid creating one ecr per env
  count                = local.env == "development" ? 1 : 0
  name                 = "web"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
