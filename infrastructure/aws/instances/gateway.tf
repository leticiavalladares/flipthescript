resource "aws_internet_gateway" "ig_vpc" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ig-vpc"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_vpc" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subnet.id

  tags = {
    Name = "nat-vpc"
  }

  depends_on = [aws_internet_gateway.ig_vpc]
}