variable "vpc_id" {}
variable "zones" {
  type = list(string)
}
variable "project_name" {}
variable "base_cidr_block" {}

# variable "route_table_id" {
#   description = "ID of the route table to associate subnets with"
#   type        = string
# }

variable "public_route_table_id" {
  description = "ID of the route table to associate subnets with"
  type        = string
}

variable "private_route_table_id" {
  description = "ID of the route table to associate subnets with"
  type        = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}