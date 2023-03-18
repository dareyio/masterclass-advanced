
resource "aws_security_group_rule" "allow_HTTP_from_internal_alb_to_wordpress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.int-alb-sg.id
  security_group_id        = aws_security_group.wordpress-sg.id
}




resource "aws_security_group_rule" "allow_all_wordpress_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress-sg.id
}

