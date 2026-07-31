# ==============================================================================
# S3 Gateway Endpoint (ap-south-1)
# ==============================================================================

resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  # Associates S3 endpoint with public and all private route tables
  route_table_ids = concat(
    [aws_route_table.public_rt.id],
    [for rt in aws_route_table.private_rt : rt.id]
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-s3-vpc-endpoint"
    }
  )
}
