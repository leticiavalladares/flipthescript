resource "aws_route_table" "rt_pub_subnet" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_vpc.id
  }

  tags = {
    Name = "rt-pub-subnet"
  }
}

resource "aws_route_table" "rt_priv_subnet_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_vpc.id
  }

  tags = {
    Name = "rt-priv-subnet-1"
  }
}

resource "aws_route_table" "rt_priv_subnet_2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_vpc.id
  }

  tags = {
    Name = "rt-priv-subnet-2"
  }
}

resource "aws_route_table_association" "pub_assoc" {
  subnet_id     = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.rt_pub_subnet.id
}

resource "aws_route_table_association" "priv_assoc_1" {
  subnet_id     = aws_subnet.priv_subnet_1.id
  route_table_id = aws_route_table.rt_priv_subnet_1.id
}

resource "aws_route_table_association" "priv_assoc_2" {
  subnet_id     = aws_subnet.priv_subnet_2.id
  route_table_id = aws_route_table.rt_priv_subnet_2.id
}