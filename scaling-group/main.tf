# main.tf
# Creating our Week 21 VPC
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
}

module "routes" {
  source                 = "./modules/routes"
  project_name           = var.project_name
  availability_zones     = var.availability_zones
  vpc_id                 = module.vpc.vpc_id
  internet_gateway_id    = module.vpc.internet_gateway_id
  nat_gateway_ids        = module.subnet.nat_gateway_ids
  public_subnet_ids      = module.subnet.public_subnet_ids
  private_subnet_ids     = module.subnet.private_subnet_ids
  has_single_nat_gateway = true
}

# Creating our two subnets
module "subnet" {
  source              = "./modules/subnet"
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  project_name        = var.project_name
  public_subnets_map  = var.public_subnets_map
  private_subnets_map = var.private_subnets_map
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id
}

module "iam_ssm" {
  source              = "./modules/iam_ssm"
  project_name        = var.project_name
  environment         = var.environment
  cwagent_config_json = filebase64("${path.module}/templates/cloudwatch-config.json")
}

module "s3_bucket" {
  source               = "./modules/s3"
  environment          = var.environment
  project_name         = var.project_name
  allow_account_id     = var.allow_account_id
  external_account_arn = var.external_account_arn
}

# Creating our security group that allows traffic from the internet
module "frontend_sg" {
  name   = "frontend"
  source = "./modules/security_group"

  environment     = var.environment
  project_name    = var.project_name
  cidr_blocks     = var.cidr_blocks
  open_cidr_block = var.open_cidr_block
  frontend_port   = var.frontend_port
  backend_port    = var.backend_port

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.subnet.public_subnet_ids
  private_subnets = module.subnet.private_subnet_ids
}

module "backend_sg" {
  name   = "backend"
  source = "./modules/security_group"

  environment     = var.environment
  project_name    = var.project_name
  cidr_blocks     = var.cidr_blocks
  open_cidr_block = var.open_cidr_block
  frontend_port   = var.frontend_port
  backend_port    = var.backend_port

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.subnet.public_subnet_ids
  private_subnets = module.subnet.private_subnet_ids
}

# Firewall configuration for the our instances
module "asg_frontend" {
  source                = "./modules/autoscaling"
  name                  = "frontend"
  project_name          = var.project_name
  instance_key_name     = var.instance_key_name
  instance_type         = var.instance_type
  asg_desired_capacity  = var.asg_desired_capacity
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  asg_health_check_type = var.asg_health_check_type

  ami_id     = module.asg_frontend.ami_id
  subnet_ids = module.subnet.public_subnet_ids

  sg_id     = module.frontend_sg.asg_sg_id
  alb_sg_id = module.frontend_sg.alb_sg_id

  target_group_arn          = module.alb_app.frontend_tg_arn
  iam_instance_profile_name = module.iam_ssm.iam_instance_profile_name

  user_data = "frontend_user_data.sh"
}

module "asg_backend" {
  source                = "./modules/autoscaling"
  name                  = "backend"
  project_name          = var.project_name
  instance_key_name     = var.instance_key_name
  instance_type         = var.instance_type
  asg_desired_capacity  = var.asg_desired_capacity
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  asg_health_check_type = var.asg_health_check_type

  ami_id     = module.asg_backend.ami_id
  subnet_ids = module.subnet.private_subnet_ids

  sg_id     = module.backend_sg.alb_sg_id
  alb_sg_id = module.backend_sg.alb_sg_id

  target_group_arn          = module.alb_app.backend_tg_arn
  iam_instance_profile_name = module.iam_ssm.iam_instance_profile_name

  user_data = "backend_user_data.sh"
}

module "alb_app" {
  source = "./modules/alb"

  name              = "app"
  environment       = var.environment
  project_name      = var.project_name
  cidr_blocks       = var.cidr_blocks
  open_cidr_block   = var.open_cidr_block
  frontend_port              = var.frontend_port
  frontend_health_check_path = var.frontend_health_check_path
  backend_port              = var.backend_port
  backend_health_check_path = var.backend_health_check_path

  security_group_id = module.frontend_sg.alb_sg_id
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.subnet.public_subnet_ids
  private_subnets   = module.subnet.private_subnet_ids
}

module "cloudwatch_agent_frontend" {
  name                = "agent-frontend"
  source              = "./modules/cloudwatch_agent"
  project_name        = var.project_name
  cwagent_config_json = filebase64("${path.module}/templates/cloudwatch-config.json")
}

module "cloudwatch_agent_backend" {
  name                = "agent-backend"
  source              = "./modules/cloudwatch_agent"
  project_name        = var.project_name
  cwagent_config_json = filebase64("${path.module}/templates/cloudwatch-config.json")
}
# TODO - Trigger for RAM
module "cloudwatch_alarm_frontend" {
  name         = "frontend-monitoring"
  source       = "./modules/cloudwatch_alarm"
  project_name = var.project_name
  # tags
  instance_type = var.instance_type
  environment   = var.environment
  ami_id        = var.iam_instance_profile_name
  instance_id   = var.allow_account_id

  asg_name             = module.asg_frontend.asg_name
  scale_out_policy_arn = module.asg_frontend.scale_out_policy_arn
  alarm_action_arn     = module.asg_frontend.scale_out_policy_arn
}

module "cloudwatch_alarm_backend" {
  name         = "backend-monitoring"
  source       = "./modules/cloudwatch_alarm"
  project_name = var.project_name
  # tags
  instance_type = var.instance_type
  environment   = var.environment
  ami_id        = var.iam_instance_profile_name
  instance_id   = var.allow_account_id

  asg_name             = module.asg_backend.asg_name
  scale_out_policy_arn = module.asg_backend.scale_out_policy_arn
  alarm_action_arn     = module.asg_backend.scale_out_policy_arn
}

# Then Lambda & S3
