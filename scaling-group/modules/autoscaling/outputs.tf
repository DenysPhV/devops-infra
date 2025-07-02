output "ami_id" {
    value = data.aws_ami.latest_amazon_linux.id
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}