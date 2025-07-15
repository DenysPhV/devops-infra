terraform {
  cloud {
    organization = "denys_filichkin"
    workspaces {
      name = "terraform-aws-dev" 
    }
  }
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
  required_version = "1.9.4"
}
