variable "project_name" {
  type        = string
  description = "Project name"
}

variable "name" {
  type        = string
  description = "Frontend or Backend"
}

variable "asg_name" {
  type        = string
  description = "Auto Scaling Group name for alarm dimension"
}

variable "scale_out_policy_arn" {
  type        = string
  description = "ARN of the scale-out policy triggered by this alarm"
}

