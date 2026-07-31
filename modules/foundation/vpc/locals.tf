locals {
  name_prefix = "${var.environment}-vpc"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  public_subnets = {
    for idx, cidr in var.public_subnet_cidrs : cidr => {
      idx  = idx + 1
      cidr = cidr
      az   = element(var.public_subnet_azs, idx)
    }
  }

  private_subnets = {
    for idx, cidr in var.private_subnet_cidrs : cidr => {
      idx  = idx + 1
      cidr = cidr
      az   = element(var.private_subnet_azs, idx)
    }
  }
}
