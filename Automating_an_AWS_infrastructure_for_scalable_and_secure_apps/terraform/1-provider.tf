provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.1.7"
  backend "s3" {
    bucket = "feb2023masterclass"
    key    = "terraformstate/terraform.tfstate"
    region = "eu-west-2"
  }
}

