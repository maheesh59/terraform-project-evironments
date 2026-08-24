# ==============================================================================
# Security Group for Interface Endpoints
# ==============================================================================

resource "aws_security_group" "vpc_endpoints" {
  name = coalesce(
    var.security_group_name,
    "${var.name_prefix}-vpc-endpoints-sg"
  )

  description = "Security group for VPC Interface Endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.endpoint_tags,
    {
      Name = coalesce(
        var.security_group_name,
        "${var.name_prefix}-vpc-endpoints-sg"
      )
    }
  )
}

# ==============================================================================
# GATEWAY ENDPOINTS
# ==============================================================================

# ------------------------------------------------------------------------------
# S3 Gateway Endpoint
# ------------------------------------------------------------------------------

resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.private_route_table_ids

  tags = merge(
    local.endpoint_tags,
    {
      Name = "${var.name_prefix}-s3-gateway-endpoint"
    }
  )
}

# ------------------------------------------------------------------------------
# DynamoDB Gateway Endpoint
# ------------------------------------------------------------------------------

resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.private_route_table_ids

  tags = merge(
    local.endpoint_tags,
    {
      Name = "${var.name_prefix}-dynamodb-gateway-endpoint"
    }
  )
}

# ==============================================================================
# INTERFACE ENDPOINTS
# ==============================================================================

# ------------------------------------------------------------------------------
# ECR API
# ------------------------------------------------------------------------------

resource "aws_vpc_endpoint" "ecr_api" {
  count = var.enable_ecr_endpoints ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge(
    local.endpoint_tags,
    {
      Name = "${var.name_prefix}-ecr-api-endpoint"
    }
  )
}

# ------------------------------------------------------------------------------
# ECR Docker
# ------------------------------------------------------------------------------

resource "aws_vpc_endpoint" "ecr_dkr" {
  count = var.enable_ecr_endpoints ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge(
    local.endpoint_tags,
    {
      Name = "${var.name_prefix}-ecr-dkr-endpoint"
    }
  )
}

# ------------------------------------------------------------------------------
# Secrets Manager
# ------------------------------------------------------------------------------

resource "aws_vpc_endpoint" "secretsmanager" {
  count = var.enable_secretsmanager_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge(
    local.endpoint_tags,
    {
      Name = "${var.name_prefix}-secretsmanager-endpoint"
    }
  )
}

# ------------------------------------------------------------------------------
# Systems Manager
# ------------------------------------------------------------------------------

resource "aws_vpc_endpoint" "ssm" {
  count = var.enable_ssm_endpoint ? 1 : 0

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge(
    local.endpoint_tags,
    {
      Name = "${var.name_prefix}-ssm-endpoint"
    }
  )
}
