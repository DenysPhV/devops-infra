output "vpc_id" {
  value = aws_vpc.this.id
}

output "route_table_id" {
  value = aws_route_table.this.id 
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}