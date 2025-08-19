variable "project_name" {
  type        = string
  description = "Project name for naming resources"
}

variable "environment" {
  type = string
}

variable "cwagent_config_json" {
  type = string
}
