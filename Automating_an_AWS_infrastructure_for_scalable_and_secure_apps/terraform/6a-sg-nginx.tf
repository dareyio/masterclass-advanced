# security group for alb, to allow acess from any where for HTTP and HTTPS traffic
resource "aws_security_group" "nginx-sg" {
  name        = "masterclass-nginx-sg"
  vpc_id      = aws_vpc.main.id
  description = "Nginx SG"


  tags = {
    Name            = "masterclass-nginx-sg"
  }

}