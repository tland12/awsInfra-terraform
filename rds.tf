resource "aws_db_instance" "project-rds" {
  identifier          = "projectrds"
  multi_az             = true
  allocated_storage    = 10
  storage_type         = "standard"
  db_name              = "MenuSelection"
  engine               = "MariaDB"
  engine_version       = "10.11.6"
  instance_class       = "db.m5.large"
  username             = "dbadmin"
  password             = "dbmypassword"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds-subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}