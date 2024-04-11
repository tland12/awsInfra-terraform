resource "aws_internet_gateway" "terra-igw" {
  vpc_id = aws_vpc.vpc.id
  tags = { Name = "terra-IGW"}
}

resource "aws_eip" "nat" {
  tags = { Name = "terra-EIP"}
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet1.id
  tags = {
    Name = "terra-NAT"
  }
}
