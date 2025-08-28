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
  name                 = "${var.project_name}-${var.name}-asg-ver-${aws_launch_template.lt.latest_version}"
  desired_capacity     = var.asg_desired_capacity
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  health_check_type    = var.asg_health_check_type
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }

  enabled_metrics = [ 
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  dynamic "tag" {
    for_each = {
      Name = "Server in ${var.name}-ASG-v${aws_launch_template.lt.latest_version}"
      value = "${var.project_name}-${var.name}-ec2"
    }
    content {
    key                 = tag.key
    value               = tag.value
    propagate_at_launch = true
   }
  }
  
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}





