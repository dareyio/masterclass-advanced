provider "aws" {
  region = "us-east-1"
}

# # Dev
terraform {
  required_version = ">= 1.1.7"
  backend "s3" {
    bucket = "feb2023masterclass"
    key    = "terraformstate/dev-terraform.tfstate"
    region = "eu-west-2"
  }
}

# Delete the .terraform folder and run terraform init
# staging
# terraform {
#   required_version = ">= 1.1.7"
#   backend "s3" {
#     bucket = "feb2023masterclass"
#     key    = "terraformstate/staging-terraform.tfstate"
#     region = "eu-west-2"
#   }
# }


# Delete the .terraform folder and run terraform init
# # Prod
# terraform {
#   required_version = ">= 1.1.7"
#   backend "s3" {
#     bucket = "feb2023masterclass"
#     key    = "terraformstate/prod-terraform.tfstate"
#     region = "eu-west-2"
#   }
# }

# Create the networking part of the infrastructure
  module "networking" {
    source = "./modules/vpc"
    cidr_block = var.root_cidr_block
    env_name = var.root_env_name
  }

# Create the security group part of the infrastructure
module "security" {
  source = "./modules/security-group"
  vpc_id =  module.networking.vpcID
}