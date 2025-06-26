variable "project" {}
variable "environment" {}
variable "region" {}
variable "vpc_cidr" {}
variable "registration_token" {
}
variable "state_bucket" {}

variable "github_url" {
  description = "URL GitHub"
  type        = string
}

variable "backend_image" {
  description = "ECR image for backend"
  type        = string
}

variable "frontend_image" {
  description = "ECR image for frontend"
  type        = string
}

variable "profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "denysfilichkin" 
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "availability_zones" {
  type = list(string)
}