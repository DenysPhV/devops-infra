variable "region" {}
variable "environment" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "availability_zones" {}
variable "vpc_cidr" {}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "project_name" {
  description = "The name of the current project we're working with"
  type        = string
}

variable "zones" {
  type = list(string)
  default = [
    "eu-west-3a",
    "eu-west-3b"
  ]
  description = "List of availability zones"
}


