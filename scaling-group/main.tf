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
  zones                  = var.availability_zones
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
  zones               = var.zones
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
  security_group_id = module.frontend_sg.alb_sg_id
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.subnet.public_subnet_ids
  private_subnets   = module.subnet.private_subnet_ids
  cidr_blocks       = var.cidr_blocks
  open_cidr_block   = var.open_cidr_block

  frontend_port              = var.frontend_port
  frontend_health_check_path = var.frontend_health_check_path

  backend_port              = var.backend_port
  backend_health_check_path = var.backend_health_check_path
}


module "cloudwatch_agent_frontend" {
  name   = "frontend"
  source = "./modules/cloudwatch_agent"

  project_name = var.project_name
  asg_name     = module.asg_frontend.asg_name

  scale_out_policy_arn = aws_autoscaling_policy.frontend_scale_out.arn
}

module "cloudwatch_alarm" {
  name         = "monitoring"
  source       = "./modules/cloudwatch_alarm"
  project_name = var.project_name

  frontend_asg_name = module.asg_frontend.asg_name
  backend_asg_name  = module.asg_backend.asg_name

  alarm_action_arn = aws_autoscaling_policy.frontend_scale_out.arn
}

resource "aws_autoscaling_policy" "frontend_scale_out" {
  name               = "${var.project_name}-frontend-scale-out"
  adjustment_type    = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown           = 300

  autoscaling_group_name = module.asg_frontend.asg_name
}

# TODO cidr block to tfvars

# change name resource
# resource "aws_route_table" "rt" {
#   vpc_id = module.vpc.vpc_id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = module.vpc.igw_id
#   }
#   tags = {
#     Name = "${var.project_name}-route-table"
#   }
# }

# resource "aws_route_table_association" "public" {
#   count          = length(module.subnet.public_subnet_ids)
#   subnet_id      = module.subnet.public_subnet_ids[count.index]
#   route_table_id = module.routes.public_route_table_id
# }

# resource "aws_route_table_association" "private" {
#   count          = length(module.subnet.private_subnet_ids)
#   subnet_id      = module.subnet.private_subnet_ids[count.index]
#   route_table_id = module.routes.private_route_table_ids[count.index]
# }


# TODO - Trigger for RAM
# Then Lambda & S3
