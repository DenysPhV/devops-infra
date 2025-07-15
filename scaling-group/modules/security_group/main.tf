resource "aws_security_group" "alb_sg" {
  name = "${var.project_name}-${var.name}-alb-sg"
  description = "Allow HTTP/HTTPS from internet"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = ["22", "80"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "egress" {
    for_each = ["53", "443"]
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "alb-sg"
  }
}

# Frontend SG — доступ тільки з ALB
resource "aws_security_group" "frontend_sg" {
  name        = "${var.project_name}-${var.name}-frontend-sg"
  description = "Allow HTTP from ALB only"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = ["80", "80"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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

# Backend SG — доступ тільки з Frontend
resource "aws_security_group" "backend_sg" {
  name        = "${var.project_name}-${var.name}-backend-sg"
  description = "Allow HTTP from Frontend only"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = ["8000", "8000"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
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
