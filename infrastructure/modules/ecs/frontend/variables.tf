variable "environment" {}
variable "private_subnets" {
  type = list(string)
}
variable "vpc_id" {}
variable "frontend_image" {}
variable "frontend_target_group_arn" {}

variable "ecs_cluster_id" {
  description = "ID of ECS cluster"
  type        = string
}