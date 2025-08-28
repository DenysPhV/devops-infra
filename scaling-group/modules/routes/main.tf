#===================================================
# Public route block
#===================================================
resource "aws_route_table" "public" {
  for_each = toset(var.availability_zones)
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-public-route-table-${each.value}"
  }
}

resource "aws_route" "public_to_internet" {
  for_each               = toset(var.availability_zones)
  route_table_id         = aws_route_table.public[each.value].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route_table_association" "public" {
  for_each       = toset(var.availability_zones)
  subnet_id      = element(var.public_subnet_ids, index(var.availability_zones, each.key))
  route_table_id = aws_route_table.public[each.key].id
}
#===================================================
# Private route block
#===================================================
resource "aws_route_table" "private" {
  for_each = toset(var.availability_zones)
  vpc_id   = var.vpc_id
  tags = {
    Name = "${var.project_name}-private-route-table-${each.value}"
  }
}

resource "aws_route" "private_to_nat" {
  for_each               = toset(var.availability_zones)
  route_table_id         = aws_route_table.private[each.value].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(var.nat_gateway_ids, index(var.availability_zones, each.value))
}

resource "aws_route_table_association" "private" {
  for_each       = toset(var.availability_zones)
  subnet_id      = element(var.private_subnet_ids, index(var.availability_zones, each.key))
  route_table_id = aws_route_table.private[each.key].id 
}
