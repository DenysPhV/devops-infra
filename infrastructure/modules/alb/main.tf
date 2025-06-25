resource "aws_lb" "this" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = []
  subnets            = var.public_subnets
}

variable "public_subnets" {
  type = list(string)
}