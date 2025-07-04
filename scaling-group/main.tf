# main.tf
# Creating our Week 21 VPC
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  public_subnets = var.public_subnets
  private_subnets= var.private_subnets
  azs            = var.availability_zones
}

# Creating our two subnets
module "subnet" {
  source          = "./modules/subnet"
  vpc_id          = module.vpc.vpc_id
  base_cidr_block = var.vpc_cidr
  zones           = var.zones
  project_name    = var.project_name
  public_route_table_id  = module.vpc.public_route_table_id
  private_route_table_id = module.vpc.private_route_table_id
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# Creating our security group that allows traffic from the internet
module "sg_frontend" {
  source       = "./modules/security_group"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  name         = "frontend"
}

module "sg_backend" {
  source       = "./modules/security_group"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  name         = "backend"
}

# Firewall configuration for the our instances
# TODO - ASG group for Front (only ALB allowed)
# TODO - ASG group for Back (only Front allowed)
module "asg_frontend" {
  source         = "./modules/autoscaling"
  name           = "frontend"
  project_name   = var.project_name
  ami_id         = module.asg_frontend.ami_id
  instance_type  = var.instance_type
  subnet_ids     = module.subnet.public_subnet_ids
  sg_id          = module.sg_frontend.sg_id
  user_data      = "frontend_user_data.sh"
}

module "asg_backend" {
  source         = "./modules/autoscaling"
  name           = "backend"
  project_name   = var.project_name
  ami_id         = module.asg_backend.ami_id
  instance_type  = var.instance_type
  subnet_ids     = module.subnet.public_subnet_ids
  sg_id          = module.sg_backend.sg_id
  user_data      = "backend_user_data.sh"
}

# TODO cidr block to tfvars

# change name resource
resource "aws_route_table" "rt" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc.igw_id
  }
  tags = {
    Name = "${var.project_name}-route-table"
  }
}

#TODO load balancer module & change name resource 
# TODO - ALB for Front 
# TODO - ALB for Back 
module "alb_frontend" {
  source            = "./modules/alb"
  name              = "frontend"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.subnet.public_subnet_ids
  project_name      = var.project_name
  target_port       = 80
  health_check_path = "/"
}

module "alb_backend" {
  source            = "./modules/alb"
  name              = "backend"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.subnet.public_subnet_ids
  project_name      = var.project_name
  target_port       = 8000
  health_check_path = "/health"
}

# TODO Trigger for CPU 
resource "aws_cloudwatch_metric_alarm" "high_cpu_frontend" {
  alarm_name          = "high_cpu_frontend"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when frontend CPU exceeds 80%"
  dimensions = {
    AutoScalingGroupName = module.asg_frontend.asg_name
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_backend" {
  alarm_name          = "high-cpu-backend"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when backend CPU exceeds 80%"
  dimensions = {
    AutoScalingGroupName = module.asg_backend.asg_name
  }
}

# TODO - Optional Trigger for RAM
# TODO - Optional add spot instaces in the code
# Then Lambda & S3
