resource "aws_security_group" "allow_http_https" {
  name        = "${var.environment_id}-allow-http-https"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main_vpc.id

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
    Name = "${var.environment_id} Allow HTTP/HTTPS"
  }
}
