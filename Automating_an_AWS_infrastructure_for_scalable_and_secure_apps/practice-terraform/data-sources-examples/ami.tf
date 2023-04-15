data "aws_ami" "latest" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["my-image-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
data "aws_availability_zones" "example" {
  state = "available"
}

resource "aws_instance" "example" {
  count = 3
  ami = data.aws_ami.latest
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.example.names[count.index]
}
