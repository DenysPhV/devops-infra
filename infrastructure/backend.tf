# terraform {
#   backend "s3" {
#     bucket         = "push-service-terraform"
#     key            = "envs/dev/terraform.tfstate"
#     region         = "eu-west-3"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#     profile        = "denysfilichkin"
#   }
# }
