resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project_name}-${var.name}-lt"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.sg_id]

  user_data = filebase64("${path.module}/templates/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg" {
  name                 = "${var.project_name}-${var.name}-asg"
  desired_capacity     = 2
  max_size             = 5
  min_size             = 2
  health_check_type    = "EC2"
  vpc_zone_identifier  = var.subnet_ids

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.name}-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

