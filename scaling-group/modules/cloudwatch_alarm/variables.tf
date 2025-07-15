variable "project_name" {
  type        = string
}

variable "name" {
  type        = string
}

variable "frontend_asg_name" {
  type        = string
}

variable "backend_asg_name" {
  type        = string
}

variable "alarm_action_arn" {
  type        = string
  description = "ARN of the alarm action (e.g., autoscaling policy)"
}