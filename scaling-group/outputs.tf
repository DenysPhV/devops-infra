output "asg_name" {
  value = aws_autoscaling_group.nginx_asg.name
}

output "public_ips" {
  value = data.aws_instances.nginx_instances.public_ips
}

output "private_ips" {
  value = data.aws_instances.nginx_instances.private_ips
}