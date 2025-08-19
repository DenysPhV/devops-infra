resource "aws_launch_template" "lt" {
  name_prefix            = "${var.project_name}-${var.name}-lt"
  image_id               = data.aws_ami.latest_amazon_linux.id
  key_name               = var.instance_key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  
  # user_data = base64encode(var.user_data)
  user_data = data.template_file.user_data.template

  # instance_market_options {
  #   market_type = "spot"
  # }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-${var.name}-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg" {
  name                 = "${var.project_name}-${var.name}-asg"
  desired_capacity     = var.asg_desired_capacity
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  health_check_type    = var.asg_health_check_type
  vpc_zone_identifier  = var.subnet_ids

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.name}-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}






