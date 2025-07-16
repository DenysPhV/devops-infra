terraform {
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.63.0"
    }
  }
  required_version = "1.12.2"
}


provider "aws" {
  profile = "denysfilichkin"
  region  = var.region
}