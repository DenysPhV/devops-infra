# create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment_name} VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment_name} Internet Gateway"
  }
}

# Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  count = length(var.zones)
  cidr_block = cidrsubnet(var.vpc_cidr, 3, count.index * 2)
  availability_zone = element(var.zones, count.index)

  tags = {
    Name = "${var.environment_name} Main subnet"
  }
}

