variable "project_name" {
  type        = string
  description = "Project prefix for naming buckets"
}

variable "environment" {
  type = string
}

variable "allow_account_id" {
  type = string
}

variable "external_account_arn" {
  type        = string
}