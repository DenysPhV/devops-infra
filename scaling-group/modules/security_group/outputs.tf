output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "frontend_sg_id" {
  value = aws_security_group.frontend_sg.id
}

output "backend_sg_id" {
  value = aws_security_group.backend_sg.id
}
