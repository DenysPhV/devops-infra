resource "aws_subnet" "this" {
  count                   = length(var.zones)
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.base_cidr_block, 8, count.index + 1)
  availability_zone       = var.zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "this" {
  count          = length(aws_subnet.this)
  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = var.route_table_id
}
