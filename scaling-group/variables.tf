variable "region" {}
variable "environment" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "availability_zones" {}
variable "vpc_cidr" {}
variable "iam_instance_profile_name" {}

variable "instance_type" {
  type    = string
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

variable "instance_key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "instance_key" {
  default = "/User/users/.ssh/tasks_key.pem"
}
variable "source_instance_internal_key" {
  default = "/User/users/.ssh/id_ed25519"
}
variable "destination_instance_internal_key" {
  default = "/home/ec2-user/.ssh/id_ed25519"
}



