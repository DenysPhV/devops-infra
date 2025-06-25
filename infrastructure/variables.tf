variable "project" {}
variable "environment" {}
variable "region" {}
variable "vpc_cidr" {}
variable "registration_token" {
}
variable "state_bucket" {}

variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}