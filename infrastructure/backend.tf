terraform {
  backend "s3" {
    bucket         = var.project
    key            = "envs/dev/terraform.tfstate"
    region         = var.region
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
