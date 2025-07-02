variable "subnet_ids" {
  type = list(string)
}

variable "project_name" {
  type = string
}

variable "ami_id" {
  description = "AMI ID for the launch template"
  type = string
}

variable "instance_type" {
  type = string
}

variable "sg_id" {
  type = string
}
