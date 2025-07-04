variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "name" {
  type        = string
  description = "Name (frontend / backend)"
}