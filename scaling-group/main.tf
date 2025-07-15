# main.tf
# Creating our Week 21 VPC
module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  project_name    = var.project_name
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.availability_zones
}

# Creating our two subnets
module "subnet" {
  source                 = "./modules/subnet"
  vpc_id                 = module.vpc.vpc_id
  base_cidr_block        = var.vpc_cidr
  zones                  = var.zones
  project_name           = var.project_name
  public_route_table_id  = module.vpc.public_route_table_id
  private_route_table_id = module.vpc.private_route_table_id
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
}

module "iam_ssm" {
  source              = "./modules/iam_ssm"
  project_name        = var.project_name
  cwagent_config_json = file("${path.module}/templates/cloudwatch-config.json")
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
module "asg_frontend" {
  source                    = "./modules/autoscaling"
  name                      = "frontend"
  project_name              = var.project_name
  instance_key_name         = var.instance_key_name
  ami_id                    = module.asg_frontend.ami_id
  instance_type             = var.instance_type
  subnet_ids                = module.subnet.public_subnet_ids
  sg_id                     = module.sg_frontend.frontend_sg_id
  alb_sg_id                 = module.sg_frontend.alb_sg_id
  target_group_arn          = module.alb_frontend.frontend_tg_arn
  iam_instance_profile_name = module.iam_ssm.iam_instance_profile_name

  user_data = "frontend_user_data.sh"
}

module "asg_backend" {
  source                    = "./modules/autoscaling"
  name                      = "backend"
  project_name              = var.project_name
  instance_key_name         = var.instance_key_name
  ami_id                    = module.asg_backend.ami_id
  instance_type             = var.instance_type
  subnet_ids                = module.subnet.public_subnet_ids
  sg_id                     = module.sg_backend.backend_sg_id
  alb_sg_id                 = module.sg_backend.alb_sg_id
  target_group_arn          = module.alb_backend.backend_tg_arn
  iam_instance_profile_name = module.iam_ssm.iam_instance_profile_name

  user_data = "backend_user_data.sh"
}

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
  target_port       = 80
  health_check_path = "/health"

}

module "cloudwatch_agent_frontend" {
  source               = "./modules/cloudwatch_agent"
  project_name         = var.project_name
  name                 = "frontend"
  asg_name             = module.asg_frontend.asg_name
  scale_out_policy_arn = aws_autoscaling_policy.frontend_scale_out.arn
}

module "cloudwatch_alarm" {
  source            = "./modules/cloudwatch_alarm"
  project_name      = var.project_name
  name              = "monitoring"
  frontend_asg_name = module.asg_frontend.asg_name
  backend_asg_name  = module.asg_backend.asg_name
  alarm_action_arn  = aws_autoscaling_policy.frontend_scale_out.arn
}

resource "aws_autoscaling_policy" "frontend_scale_out" {
  name                   = "${var.project_name}-frontend-scale-out"
  autoscaling_group_name = module.asg_frontend.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
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


# TODO - Optional Trigger for RAM
# Then Lambda & S3
