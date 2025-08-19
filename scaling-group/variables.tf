variable "region" {
  type = string
}
variable "environment" {
  type = string
}
# ================================
# Subnets
# ================================
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnets_map" {
  description = "Map of AZ to CIDR for public subnets"
  type        = map(string)
}

variable "private_subnets_map" {
  description = "Map of AZ to CIDR for private subnets"
  type        = map(string)
}
# ================================
# Zones
# ================================
variable "availability_zones" {
  type = list(string)
}
variable "zones" {
  type        = list(string)
  description = "List of availability zones"
}

# ================================
# CIDR blocks
# ================================
variable "open_cidr_block" {
  type = string
}
variable "cidr_blocks" {
  type = list(string)
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

# ================================
# Ports
# ================================
variable "frontend_port" {
  type = string
}

variable "backend_port" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "project_name" {
  description = "The name of the current project we're working with"
  type        = string
}

variable "instance_key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "instance_key" {
  type = string
}
variable "source_instance_internal_key" {
  type = string
}
variable "destination_instance_internal_key" {
  type = string
}

variable "asg_desired_capacity" {
  type = string
}

variable "asg_health_check_type" {
  type = string
}

variable "asg_min_size" {
  type = string
}
variable "asg_max_size" {
  type = string
}

variable "allow_account_id" {
  type = string
}

variable "external_account_arn" {
  type        = string
  description = "ARN of another AWS account that is allowed access to S3"
}

variable "frontend_health_check_path" {
  type        = string
  description = "Health check path for frontend"
}

variable "backend_health_check_path" {
  type        = string
  description = "Health check path for backend"
}








