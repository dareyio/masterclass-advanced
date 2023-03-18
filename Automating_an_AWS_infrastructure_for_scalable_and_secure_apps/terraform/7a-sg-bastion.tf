# security group for alb, to allow acess from any where for HTTP and HTTPS traffic
resource "aws_security_group" "bastion-sg" {
  name        = "masterclass-bastion-sg"
  vpc_id      = aws_vpc.main.id
  description = "Bastion SG"


  tags = {
    Name            = "masterclass-bastion-sg"
  }

}