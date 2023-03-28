# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = var.cidr_block
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = true
  enable_classiclink             = false
  enable_classiclink_dns_support = false
  tags = {
    Name = "${var.env_name}-masterclass-VPC"
  }
}