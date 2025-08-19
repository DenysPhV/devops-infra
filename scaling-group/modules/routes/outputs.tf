output "public_route_table_id" {
  value =  [for r in aws_route_table.public : r.id]
}

output "private_route_table_ids" {
  value = [for r in aws_route_table.private : r.id]
}

