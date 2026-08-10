resource "aws_ecr_repository" "this" {
  for_each             = var.repositories
  name                 = "${var.environment}-${each.key}"
  image_tag_mutability = each.value.image_tag_mutability

  # Basic image scanning on push
  image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }

  tags = local.common_tags
}
