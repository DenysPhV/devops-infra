variable "region" {
  default = "eu-west-3"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "project_name" {
  description = "The name of the current project we're working with"
  type        = string
  default     = "matts-week21-tf-project"
}

variable "zones" {
  type = list(string)
  default = [
    "eu-west-3a",
    "eu-west-3b"
  ]
  description = "List of availability zones"
}

# variable "vpc_cidr" {
#   description = "VPC CIDR"
#   default = "10.0.0.0/24"
# }
