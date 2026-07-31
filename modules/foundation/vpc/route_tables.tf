# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = local.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Tables
resource "aws_route_table" "private_rt" {
  for_each = local.private_subnets
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[var.public_subnet_cidrs[each.value.idx - 1]].id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-rt-${each.value.idx}"
    }
  )
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = local.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private_rt[each.key].id
}
