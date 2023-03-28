resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name            = "masterclass-main-IG"
  }

}

