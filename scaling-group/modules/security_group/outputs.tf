output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "ID of the ALB security group"
}

output "asg_sg_id" {
  value       = aws_security_group.asg_sg.id
  description = "ID of the ASG security group"
}
