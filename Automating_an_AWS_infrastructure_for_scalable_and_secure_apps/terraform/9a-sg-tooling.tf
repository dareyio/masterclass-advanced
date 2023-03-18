# security group for alb, to allow acess from any where for HTTP and HTTPS traffic
resource "aws_security_group" "tooling-sg" {
  name        = "masterclass-tooling-sg"
  vpc_id      = aws_vpc.main.id
  description = "tooling SG"


  tags = {
    Name            = "masterclass-tooling-sg"
  }

}