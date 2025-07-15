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

variable "project_name" {
    type = string
  
}

variable "name" {
  type        = string
  description = "Name prefix for ALB and resources (e.g. frontend, backend)"
}

variable "target_port" {
  type        = number
  description = "Port number for target group (e.g. 80 for frontend, 8000 for backend)"
}

variable "health_check_path" {
  type        = string
  description = "Health check path for the target group"
}

