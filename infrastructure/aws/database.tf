resource "aws_db_instance" "movie_db" {
  allocated_storage      = var.db_storage      // 10 GiB 
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.movie_db_pw.secret_string))["movie_db_password"]
  skip_final_snapshot    = var.db_skip_last_snapshot
  db_subnet_group_name   = aws_db_subnet_group.db_sg.name
  vpc_security_group_ids = [aws_security_group.db_movie_sg.id]

tags = {
    Name = "movie-db"
}

depends_on = [
    aws_db_subnet_group.db_sg,
    aws_vpc.vpc,
    aws_subnet.pub_subnet,
    aws_subnet.priv_subnet_1,
    aws_subnet.priv_subnet_2,
    aws_security_group.bastion_host_sg,
    aws_security_group.db_movie_sg
]
}