resource "aws_security_group" "alb_sg" {
  name = "${var.project_name}-${var.name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(["80", "443", "8000"])
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.open_cidr_block]
    }
  }

  dynamic "ingress" {
    for_each = ["22", "53" ]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.name}-sg"
  }
}

# Frontend SG — доступ тільки з ALB
resource "aws_security_group" "asg_sg" {
  name        = "${var.project_name}-${var.name}-sg"
  description = "Security group for ASG (EC2 instances)"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(["80", "443", "8000"])
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      security_groups = [aws_security_group.alb_sg.id]
    }
  }

  dynamic "ingress" {
    for_each = ["22", "53"]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.name}-sg"
  }
}

