# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = "100.0.0.0/16"
  enable_dns_support             = true
  enable_dns_hostnames           = true
  enable_classiclink             = false
  enable_classiclink_dns_support = false
  tags = {
    Name = "masterclass-VPC"
  }
}