variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones for public subnets"
}