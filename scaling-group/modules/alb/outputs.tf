output "frontend_tg_arn" {
  value = aws_lb_target_group.frontend.arn
}

output "backend_tg_arn" {
  value = aws_lb_target_group.backend.arn
}

output "alb_arn" {
  value       = aws_lb.web_lb.arn
  description = "ARN of the ALB"
}

output "alb_dns_name" {
  value       = aws_lb.web_lb.dns_name
  description = "DNS name of the ALB"
}


