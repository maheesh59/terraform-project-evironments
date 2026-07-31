resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = var.buckets

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = each.value.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = each.value.kms_key_arn
    }
    bucket_key_enabled = each.value.kms_key_arn != null ? true : false
  }
}
