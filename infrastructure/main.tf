module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"
  name = "${var.project}-${var.environment}-vpc"
  cidr = var.vpc_cidr
  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  enable_nat_gateway = true
}

module "ecs" {
  source = "./modules/ecs"
}

module "ecr" {
  source = "./modules/ecr"
}

module "alb" {
  source = "./modules/alb"
}
