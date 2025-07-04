variable "region" {}
variable "state_bucket" {}
variable "table_name" {}
variable "environment_id" {}
variable "environment_name" {}
variable "purpose" {}

variable "zones" {
  type = list(string)
  default = [
    "eu-west-3a",
    "eu-west-3b",
    "eu-west-3c"
  ]
  description = "List of availability zones"
}

variable "instance_count" {
  default = "1"
}
variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
}

variable "instance_key_name" {}