data "aws_ami" "aws_basic_linux" {
  owners      = [local.aws_owner_id]
  most_recent = true

  filter {
    name   = "name"
    values = [local.aws_ami_name]
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
  name_prefix          = "ecs-launch-config-"
  image_id             = data.aws_ami.aws_basic_linux.id
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=cluster-${local.resource_suffix} >> /etc/ecs/ecs.config"
  instance_type        = "t2.micro"
  key_name             = "talent-academy-myec2"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "asg-${local.resource_suffix}"
  vpc_zone_identifier  = [for item in local.private_snets : aws_subnet.subnet[item].id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"

  lifecycle {
    create_before_destroy = true
  }
}