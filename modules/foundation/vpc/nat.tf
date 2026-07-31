resource "aws_eip" "nat" {
  for_each = local.public_subnets
  domain   = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-eip-${each.value.idx}"
    }
  )
}

resource "aws_nat_gateway" "nat" {
  for_each      = local.public_subnets
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  depends_on = [aws_internet_gateway.igw]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-gw-${each.value.idx}"
    }
  )
}
