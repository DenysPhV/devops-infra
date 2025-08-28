variable "project_name" {
  type        = string
}

variable "name" {
  type        = string
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
  description = "AMI ID for the launch template"
}

variable "instance_id" {
  type = string
  description = "ID of the EC2 instance to monitor (optional if ASG used)"
}

# variable "frontend_asg_name" {
#   type        = string
# }

# variable "backend_asg_name" {
#   type        = string
# }

variable "alarm_action_arn" {
  type        = string
  description = "ARN of the alarm action (e.g., autoscaling policy)"
}

variable "scale_out_policy_arn" {
  type        = string
  description = "ARN of the scale-out policy triggered by this alarm"
}

variable "asg_name" {
  type        = string
  description = "Auto Scaling Group name for alarm dimension"
}