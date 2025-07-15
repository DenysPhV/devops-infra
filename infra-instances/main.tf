provider "aws" {
    profile = "denysfilichkin"
    region = var.region
  default_tags {
    tags = {
      Environment = var.environment_id
      Role = "${var.environment_name} Networking"
      Purpose = var.purpose
    }
  }
}

# Створення Route Table
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "MainRouteTable"
  }
}

resource "aws_route_table_association" "main_route_association" {
  count = length(var.zones)
  subnet_id = aws_subnet.main_subnet[count.index].id
  route_table_id = aws_route_table.main_route_table.id
}

# terraform {
#   backend "s3" {
#     region = "eu-west-3"
#     bucket = "ec-terraform"
#     key = "state-bucket/terraform.tfstate"
#     dynamodb_table = "ec-terraform-tb"
#     profile = "denysfilichkin"
#   }
# }