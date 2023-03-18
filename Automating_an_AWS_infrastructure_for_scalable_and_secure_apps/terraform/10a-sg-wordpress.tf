# security group for alb, to allow acess from any where for HTTP and HTTPS traffic
resource "aws_security_group" "wordpress-sg" {
  name        = "masterclass-wordpress-sg"
  vpc_id      = aws_vpc.main.id
  description = "wordpress SG"


  tags = {
    Name            = "masterclass-wordpress-sg"
  }

}