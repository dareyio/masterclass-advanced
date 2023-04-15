resource "aws_iam_role" "efs_access_role" {
  name = "efs-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "efs_access_policy" {
  name = "efs-access-policy"
  role = aws_iam_role.efs_access_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:List*"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "efs_access_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess"
  role       = aws_iam_role.efs_access_role.name
}

resource "aws_iam_instance_profile" "efs_access_instance_profile" {
  name = "efs-access-instance-profile"
  role = aws_iam_role.efs_access_role.name
}

resource "aws_launch_template" "tooling-launch-template" {
  name = "masterclass-tooling"
  
  iam_instance_profile {
    name = aws_iam_instance_profile.efs_access_instance_profile.name
  }
  
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
    }
  }

  image_id = "ami-0b0af3577fe5e3532"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  key_name = "devops"

  monitoring {
    enabled = true
  }

  placement {
    availability_zone = "us-east-1a"
  }

  vpc_security_group_ids = [aws_security_group.tooling-sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name            = "tooling-launch-template"
    }
  }

  user_data = filebase64("${path.module}/bin/tooling.sh")
}