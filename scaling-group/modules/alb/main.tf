resource "random_string" "suffix" {
  length  = 7
  upper   = false
  special = false
}

resource "aws_lb" "web_lb" {
  name               = "${var.environment}-${random_string.suffix.result}-${var.name}-web-lb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnets
}

# Creating our Application Load Balancer target group
resource "aws_lb_target_group" "frontend" {
  name = "${var.environment}-${random_string.suffix.result}-${var.name}-fe-tg"
  port        = var.frontend_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  deregistration_delay = 5

  health_check {
    path                = var.frontend_health_check_path
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "backend" {
  name = "${var.environment}-${random_string.suffix.result}-${var.name}-be-tg"
  port        = var.backend_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  deregistration_delay = 5

  health_check {
    path                = var.backend_health_check_path
    matcher             = "200"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# frontend is here
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["${var.backend_health_check_path}*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}