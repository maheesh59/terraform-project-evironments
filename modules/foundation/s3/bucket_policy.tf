resource "aws_s3_bucket_policy" "this" {
  for_each = {
    for k, v in var.buckets : k => v if v.bucket_policy_json != null
  }

  bucket = aws_s3_bucket.this[each.key].id
  policy = each.value.bucket_policy_json

  depends_on = [aws_s3_bucket_public_access_block.this]
}
