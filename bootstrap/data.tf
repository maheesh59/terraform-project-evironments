# Fetches the AWS Account ID and ARN of the identity running Terraform
data "aws_caller_identity" "current" {}
