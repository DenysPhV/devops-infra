# Creating our Week 21 VPC
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = "10.0.0.0/16"
  project_name = var.project_name
}

# Creating our two subnets
module "subnet" {
  source          = "./modules/subnet"
  vpc_id          = module.vpc.vpc_id
  base_cidr_block = "10.0.0.0/16"
  zones           = var.zones
  route_table_id  = module.vpc.route_table_id
  project_name    = var.project_name
}

# Creating our security group that allows traffic from the internet
module "sg" {
  source       = "./modules/security_group"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

# Firewall configuration for the our instances
module "asg" {
  source         = "./modules/autoscaling"
  subnet_ids     = module.subnet.subnet_ids
  project_name   = var.project_name
  ami_id         = module.asg.ami_id
  instance_type  = var.instance_type
  sg_id          = module.sg.sg_id
}


resource "aws_route_table" "matts-week-21-rt" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc.igw_id
  }
  tags = {
    Name = "${var.project_name}-route-table"
  }
}

# Creating our Application Load Balancer target group
resource "aws_lb_target_group" "matts-week21-lbtg" {
  name     = "${var.project_name}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-autoscaling"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggered when CPU > 80%"
  dimensions = {
    AutoScalingGroupName = module.asg.asg_name
  }
}

