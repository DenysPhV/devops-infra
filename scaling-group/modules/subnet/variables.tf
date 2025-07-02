variable "vpc_id" {}
variable "zones" {
  type = list(string)
}
variable "project_name" {}
variable "base_cidr_block" {
  default = "10.0.0.0/16"
}

variable "route_table_id" {
  description = "ID of the route table to associate subnets with"
  type        = string
}