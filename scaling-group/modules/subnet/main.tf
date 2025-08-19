#modules/subnet/main.tf
resource "aws_subnet" "public" {
  for_each = var.public_subnets_map
  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${each.key}"
  }
}

resource "aws_eip" "nat" {
  for_each = var.public_subnets_map
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = var.public_subnets_map
  subnet_id     = aws_subnet.public[each.key].id
  allocation_id = aws_eip.nat[each.key].id
  tags = {
    Name = "${var.project_name}-nat-gw-${each.key}"
  }

   depends_on = [var.internet_gateway_id]
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets_map
  vpc_id                  = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-${each.key}"
  }
}


