resource "aws_s3_bucket" "state_bucket" {
  bucket        = "${var.project_name}-${data.aws_caller_identity.current.account_id}"
  force_destroy = false

  tags = {
    Name      = "${var.project_name}-bucket"
    ManagedBy = "Terraform-Bootstrap"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.state_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket                  = aws_s3_bucket.state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- SSL/TLS Enforcement Policy ---

data "aws_iam_policy_document" "enforce_tls" {
  statement {
    sid    = "EnforceTLSRequestsOnly"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.state_bucket.arn,
      "${aws_s3_bucket.state_bucket.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "enforce_tls_policy" {
  bucket = aws_s3_bucket.state_bucket.id
  policy = data.aws_iam_policy_document.enforce_tls.json

  depends_on = [aws_s3_bucket_public_access_block.public_block]
}
