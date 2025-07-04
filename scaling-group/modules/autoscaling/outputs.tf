output "ami_id" {
    description = "AMI ID used in the launch template"
    value = data.aws_ami.latest_amazon_linux.id
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}