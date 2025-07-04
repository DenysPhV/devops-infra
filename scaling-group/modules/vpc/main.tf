# modules/vpc/main.tf

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.project_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# resource "aws_route_table" "this" {
#   vpc_id = aws_vpc.this.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.this.id
#   }

#   tags = {
#     Name = "${var.project_name}-route-table"
#   }
# }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# resource "aws_subnet" "public" {
#   count                   = length(var.public_subnets)
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = var.public_subnets[count.index]
#   availability_zone       = element(var.azs, count.index)
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "${var.project_name}-public-${count.index}"
#   }
# }

# resource "aws_subnet" "private" {
#   count                   = length(var.public_subnets)
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = var.private_subnets[count.index]
#   availability_zone       = element(var.azs, count.index)
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "${var.project_name}-public-${count.index}"
#   }
# }
