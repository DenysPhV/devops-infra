variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "name" {
  type        = string
  description = "Name (frontend / backend)"
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}


variable "open_cidr_block" {
  description = "List OPEN CIDR-addresses"
  type = string
}

variable "cidr_blocks" {
  type        = list(string)
  description = "List CIDR-addresses, which have to permission"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "frontend_port" {
  type = string
}

variable "backend_port" {
  type = string
}





