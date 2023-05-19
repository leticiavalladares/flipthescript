data "aws_ami" "aws_basic_linux" {
  owners      = [var.aws_owner_id]
  most_recent = true

  filter {
    name   = "name"
    values = [var.aws_ami_name]
  }
}

resource "aws_instance" "pub_server" {
  ami                    = data.aws_ami.aws_basic_linux.id
  instance_type          = var.aws_ec2_type
  subnet_id              = aws_subnet.pub_subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
  key_name               = var.my_keypair
  user_data = templatefile("${path.module}/user-data.sh.tpl",
    {
      db_endpoint = aws_db_instance.movie_db.address,
      db_password = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.movie_db_pw.secret_string))["movie_db_password"]
  })

  tags = {
    Name = "pub-server"
  }

  depends_on = [
    aws_vpc.vpc,
    aws_subnet.pub_subnet,
    aws_subnet.priv_subnet_1,
    aws_subnet.priv_subnet_2,
    aws_security_group.bastion_host_sg
  ]
}