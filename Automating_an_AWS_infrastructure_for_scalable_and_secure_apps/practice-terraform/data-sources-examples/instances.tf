data "aws_availability_zones" "example" {
  state = "available"
}

resource "aws_instance" "example" {
  count = 3
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.example.names[count.index]
}
