output "private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "backend_target_group_arn" {
  value = module.alb.backend_target_group_arn
}

output "frontend_target_group_arn" {
  value = module.alb.frontend_target_group_arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}