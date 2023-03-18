
resource "aws_security_group_rule" "allow_SSH_from_dareyio_enginers" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["156.232.55.6/32"]
  security_group_id = aws_security_group.bastion-sg.id
}


resource "aws_security_group_rule" "allow_SSH_from_partner_enginers" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["176.251.55.6/32"]
  security_group_id = aws_security_group.bastion-sg.id
}

resource "aws_security_group_rule" "allow_all_bastion_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion-sg.id
}


resource "aws_security_group_rule" "allow_SSH_from_all" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion-sg.id
}
