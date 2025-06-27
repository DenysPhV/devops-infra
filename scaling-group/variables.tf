variable "region" {
  default = "eu-west-3"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "SSH Key Pair name"
  type        = string
}
