resource "aws_db_subnet_group" "masterclass-rds-subnet-group" {
  name = "masterclass-rds-subnet-group"
  subnet_ids = [aws_subnet.PrivateSubnet-3.id,
  aws_subnet.PrivateSubnet-4.id]

  tags = merge(local.tags,
  { Name = "masterclass-rds-subnet-group" })
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "masterclass-RDS" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = "masterclassDB"
  username               = "masterclass"
  password               = "pblmasterclass"
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.masterclass-rds-subnet-group.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.datalayer-sg.id]
  multi_az               = "true"
}
