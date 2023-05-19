resource "aws_vpc" "vpc" {
  cidr_block       = var.aws_vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "vpc"
  }
}

resource "aws_subnet" "priv_subnet_1" {
  vpc_id                = aws_vpc.vpc.id
  cidr_block            = var.aws_priv_subnet_cidr_block_1
  availability_zone     = "eu-central-1a"

  tags = {
    Name = "priv-subnet-2"
  }
}

resource "aws_subnet" "priv_subnet_2" {
  vpc_id                = aws_vpc.vpc.id
  cidr_block            = var.aws_priv_subnet_cidr_block_2
  availability_zone     = "eu-central-1b"

  tags = {
    Name = "priv-subnet-1"
  }
}

resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.aws_pub_subnet_cidr_block
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-subnet"
  }
}

resource "aws_db_subnet_group" "db_sg" {
  name        = "database-subnet-group"
  description = "Subnets where RDS will be deployed"
  subnet_ids  = [
    aws_subnet.priv_subnet_1.id,
    aws_subnet.priv_subnet_2.id
  ]

  tags = {
    Name = "database-subnet-group"
  }
}

data "aws_secretsmanager_secret" "movie_db_secret"{
  name = "movie-db-password"
}

data "aws_secretsmanager_secret_version" "movie_db_pw" {
  secret_id = data.aws_secretsmanager_secret.movie_db_secret.id
}