variable "owner_email" {
  type    = string
  default = "infradev@darey.io.com"
}

variable "environment" {
  type = string
  default = "dev"
}

locals {
  tags = {

    Enviroment      = var.environment
    Owner-Email     = var.owner_email
    Managed-By      = "Terraform"
    Billing-Account = "1234567890"
  }
  environment = var.environment

}