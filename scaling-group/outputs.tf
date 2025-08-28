output "LB_DNS" {
  value = module.alb_app.alb_dns_name
}

output "frontend_ami_id" {
  value = module.asg_frontend.ami_id
}
