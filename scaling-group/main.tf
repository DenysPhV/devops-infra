provider "aws" {
    profile = "denysfilichkin"
    region = var.region
}

resource "aws_launch_template" "nginx_lt" {
  name_prefix   = "nginx-lt-"
  image_id = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    subnet_id = aws_subnet.main_subnet.id
    security_groups = [aws_security_group.nginx_sg.id]
  }

  user_data = filebase64("${path.module}/templates/user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "nginx-instance"
    }
  }
}

resource "aws_autoscaling_group" "nginx_asg" {
  name                      = "nginx-asg"
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1
  health_check_type         = "EC2"
  launch_template {
    id      = aws_launch_template.nginx_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = [aws_subnet.main_subnet.id]
  target_group_arns   = []

  tag {
    key                 = "Name"
    value               = "nginx-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-3a"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.rt.id
}

