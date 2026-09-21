resource "aws_ecr_repository" "this" {
  for_each             = toset(var.service_names)
  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_lifecycle_policy_document" "this" {
  rule {
    priority    = 1
    description = "Keep last 10 tagged images"

    selection {
      tag_status       = "tagged"
      tag_pattern_list = ["*"]
      count_type       = "imageCountMoreThan"
      count_number     = 10
    }
  }

  rule {
    priority    = 2
    description = "Expire untagged images after 14 days"

    selection {
      tag_status   = "untagged"
      count_type   = "sinceImagePushed"
      count_unit   = "days"
      count_number = 14
    }
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = aws_ecr_repository.this
  repository = each.value.name
  policy     = data.aws_ecr_lifecycle_policy_document.this.json
}
