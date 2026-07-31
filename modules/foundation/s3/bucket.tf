resource "aws_s3_bucket" "this" {
  for_each = var.buckets

  bucket        = each.value.bucket_name
  force_destroy = each.value.force_destroy

  tags = merge(
    local.common_tags,
    {
      Name    = each.value.bucket_name
      Purpose = each.key
    },
    each.value.tags
  )
}

# Public access block for each bucket
resource "aws_s3_bucket_public_access_block" "this" {
  for_each = {
    for k, v in var.buckets : k => v if v.block_public_access
  }

  bucket = aws_s3_bucket.this[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
