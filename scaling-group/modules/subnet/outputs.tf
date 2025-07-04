output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "subnet_ids" {
  value = concat(
    [for s in aws_subnet.public : s.id],
    [for s in aws_subnet.private : s.id]
  )
}

