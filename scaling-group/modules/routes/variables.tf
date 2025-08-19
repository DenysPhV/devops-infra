variable "project_name" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "has_single_nat_gateway" {
  type = bool
  default = true
  description = "Toggle for environments to use 1 NAT gateway for all AZs"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "internet_gateway_id" {
  type = string
  description = "for two-way access (Internet ↔ public resources)"
}

variable "nat_gateway_ids" {
  type = list(string)
  description = "only for outgoing traffic (private → Internet), without incoming connections"
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}
