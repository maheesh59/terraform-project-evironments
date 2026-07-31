resource "aws_s3_bucket_lifecycle_configuration" "this" {
  for_each = {
    for k, v in var.buckets : k => v if v.enable_lifecycle_rules
  }

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    id     = "default-lifecycle-rule"
    status = "Enabled"

    filter {}

    transition {
      days          = each.value.lifecycle_transition_ia_days
      storage_class = "STANDARD_IA"
    }

    dynamic "transition" {
      for_each = each.value.lifecycle_transition_glacier_days != null ? [1] : []
      content {
        days          = each.value.lifecycle_transition_glacier_days
        storage_class = "GLACIER"
      }
    }

    noncurrent_version_expiration {
      noncurrent_days = each.value.lifecycle_noncurrent_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
