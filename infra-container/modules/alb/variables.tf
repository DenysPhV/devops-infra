variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet IDs"
}

# output "alb_arn" {
#   value = aws_lb.this.arn
# }

# output "alb_dns_name" {
#   value = aws_lb.this.dns_name
# }

