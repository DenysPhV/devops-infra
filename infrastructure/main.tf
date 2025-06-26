module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"
  name = "${var.project}-${var.environment}-vpc"
  cidr = var.vpc_cidr
  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  enable_nat_gateway = true
}

module "ecs" {
  source = "./modules/ecs"
  environment = var.environment
  private_subnets  = module.vpc.private_subnets
  vpc_id  = module.vpc.vpc_id
  backend_image = var.backend_image
  backend_target_group_arn  = module.alb.backend_target_group_arn
  ecs_cluster_id = aws_ecs_cluster.main.id
}

module "ecs_frontend" {
  source               = "./modules/ecs/frontend"
  environment          = var.environment
  private_subnets      = module.vpc.private_subnets
  vpc_id               = module.vpc.vpc_id
  frontend_image       = var.frontend_image
  frontend_target_group_arn  = module.alb.frontend_target_group_arn
  ecs_cluster_id = aws_ecs_cluster.main.id
}

module "ecr" {
  source = "./modules/ecr"
}

module "alb" {
  source          = "./modules/alb"
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
}

resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-cluster"
}
