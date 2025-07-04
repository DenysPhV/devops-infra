variable "subnet_ids" {
  type = list(string)
}

variable "project_name" {
  type = string
}

variable "name" {
  type        = string
  description = "Name (frontend / backend)"
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

variable "user_data" {
  type        = string
  description = "Name of user_data script file"
}
