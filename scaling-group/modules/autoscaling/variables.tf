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

variable "alb_sg_id" {
  description = "Security Group ID of ALB that is allowed to access the frontend"
  type        = string
}

variable "sg_id" {
  description = "Security Group ID to attach to the launch template"
  type        = string
}

variable "user_data" {
  type        = string
  description = "Name of user_data script file"
}

variable "iam_instance_profile_name" {
  type        = string
  description = "IAM instance profile name for EC2 SSM access"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the target group for ALB"
}

variable "instance_key_name" {
  description = "Name of the EC2 key pair to use for SSH"
  type        = string
}


