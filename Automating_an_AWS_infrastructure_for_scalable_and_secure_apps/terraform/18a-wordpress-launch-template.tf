# launch template for wordpress

resource "aws_launch_template" "wordpress-launch-template" {
  name = "masterclass-wordpress"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }


  image_id = "ami-0b0af3577fe5e3532"

  // "ami-0b0af3577fe5e3532"
  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  key_name = "devops"


  monitoring {
    enabled = true
  }

  placement {
    availability_zone = "us-east-1a"
  }


  vpc_security_group_ids = [aws_security_group.wordpress-sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.tags,
    { Name = "wordpress-launch-template" })
  }

  user_data = filebase64("${path.module}/bin/wordpress.sh")

}