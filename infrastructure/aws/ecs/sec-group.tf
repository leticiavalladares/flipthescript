resource "aws_security_group" "ecs_sg" {
  name   = "ecs-sg-${local.resource_suffix}"
  vpc_id = aws_vpc.vpc["external"].id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-sg-${local.resource_suffix}"
  }
}

resource "aws_security_group" "lb_sg" {
  name   = "alb-sg-${local.resource_suffix}"
  vpc_id = aws_vpc.vpc["external"].id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg-${local.resource_suffix}"
  }
}

resource "aws_security_group" "task_sg" {
  name   = "task-sg-${local.resource_suffix}"
  vpc_id = aws_vpc.vpc["external"].id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task-sg-${local.resource_suffix}"
  }
}