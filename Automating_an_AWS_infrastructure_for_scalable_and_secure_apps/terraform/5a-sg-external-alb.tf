# security group for alb, to allow acess from any where for HTTP and HTTPS traffic
resource "aws_security_group" "ext-alb-sg" {
  name        = "masterclass-ext-alb-sg"
  vpc_id      = aws_vpc.main.id
  description = "External ALB SG"


  tags = {
    Name            = "masterclass-ext-alb-sg"
  }

}