resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }
  tags = { Name = "public-rt" }
}

resource "aws_route_table" "private-rt" {
  depends_on = [
    aws_nat_gateway.nat,
    aws_vpc.vpc
  ]
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "private-rt" }
}




resource "aws_route_table_association" "terra-routing-public1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "terra-routing-public2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_route_table_association" "terra-routing-web1" {
  subnet_id      = aws_subnet.web-subnet1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "terra-routing-web2" {
  subnet_id      = aws_subnet.web-subnet2.id
  route_table_id = aws_route_table.private-rt.id
}


resource "aws_route_table_association" "terra-routing-was1" {
  subnet_id      = aws_subnet.was-subnet1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "terra-routing-was2" {
  subnet_id      = aws_subnet.was-subnet2.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "terra-routing-rds1" {
  subnet_id      = aws_subnet.rds-subnet2.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "terra-routing-rds2" {
  subnet_id      = aws_subnet.rds-subnet2.id
  route_table_id = aws_route_table.private-rt.id
}
