resource "aws_kms_key" "state_key" {
  description             = "KMS Key for Terraform State Buckets"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name      = "${var.project_name}-kms"
    ManagedBy = "Terraform-Bootstrap"
  }
}

resource "aws_kms_alias" "state_key_alias" {
  name          = "alias/${var.project_name}-kms"
  target_key_id = aws_kms_key.state_key.key_id
}
