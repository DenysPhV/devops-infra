variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging"
}
variable "vpc_cidr" {
  type = string
}
variable "zones" {
  type = list(string)
}

variable "internet_gateway_id" {
  type        = string
  description = "ID of the Internet Gateway (for depends_on)"
}

# ===============================
# Maps
# ===============================
variable "public_subnets_map" {
  type        = map(string)
  description = "Map of public subnets: { az = cidr }"
}

variable "private_subnets_map" {
  type        = map(string)
  description = "Map of private subnets: { az = cidr }"
}