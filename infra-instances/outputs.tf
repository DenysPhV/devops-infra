
output "main_subnet_ids" {
  value = aws_subnet.main_subnet.*.id
}

output "bastion_server_ip" {
  value = aws_instance.bastion.*.public_ip
}

