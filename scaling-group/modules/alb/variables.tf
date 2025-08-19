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

variable "private_subnets" {
  type = list(string)
}

variable "project_name" {
    type = string
  
}

variable "security_group_id" {
  description = "ID of the security group for frontend ALB"
  type        = string
}

variable "name" {
  type        = string
  description = "Name prefix for ALB and resources (e.g. frontend, backend)"
}


variable "cidr_blocks" {
  type        = list(string)
  description = "List CIDR-addresses, which have to permission"
}

variable "open_cidr_block" {
  description = "List OPEN CIDR-addresses"
  type = string
}

variable "frontend_port" {
  type = string
}

variable "backend_port" {
  type = string
}

variable "frontend_health_check_path" {
  type        = string
  description = "Health check path for frontend"
}

variable "backend_health_check_path" {
  type        = string
  description = "Health check path for backend"
}






