# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = var.cidr_block
  enable_dns_support             = var.enable_dns_support
  tags = {
    Name = "${var.env_name}-masterclass-VPC"
  }
}

