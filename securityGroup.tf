#web ELB SG
resource "aws_security_group" "elb_http" {
  name        = "elb_http"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web-ELB-sg"
  }
}

# Bastion SG
resource "aws_security_group" "bastion_sg"{
  name        = "bastion_sg"
  description = "bastion_SG"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "Bastion-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_bastion" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_bastion" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# WEB SG
resource "aws_security_group" "web_sg"{
  name        = "webInstance_sg"
  description = "webinstance_SG"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "Web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_web1" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = aws_subnet.public-subnet1.cidr_block
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_web2" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = aws_subnet.public-subnet2.cidr_block
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_Apache" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_Apache" {
  security_group_id = aws_security_group.web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# WAS SG
resource "aws_security_group" "was_sg"{
  name        = "was_sg"
  description = "was_SG"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "WAS-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_was1" {
  security_group_id = aws_security_group.was_sg.id
  cidr_ipv4         = aws_subnet.public-subnet1.cidr_block
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_SSH_was2" {
  security_group_id = aws_security_group.was_sg.id
  cidr_ipv4         = aws_subnet.public-subnet2.cidr_block
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tomcat" {
  security_group_id = aws_security_group.was_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_Tomcat" {
  security_group_id = aws_security_group.was_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# RDS SG
resource "aws_security_group" "rds_sg"{
  name        = "rds_sg"
  description = "rds_sgGroup"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "RDS-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_RDS" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
