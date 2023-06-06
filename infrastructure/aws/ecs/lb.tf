resource "aws_lb" "lb" {
  name            = "alb-${local.resource_suffix}"
  subnets         = [for item in local.public_snets : aws_subnet.subnet[item].id]
  security_groups = [aws_security_group.lb_sg.id]

  tags = {
    Name = "alb-${local.resource_suffix}"
  }
}

resource "aws_lb_target_group" "lb_tgt_group" {
  name        = "tgt-group-${local.resource_suffix}"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc["external"].id
  target_type = "instance"

  tags = {
    Name = "tgt-group-${local.resource_suffix}"
  }
}

resource "aws_lb_target_group_attachment" "lb_tgt_ec2_att" {
  target_group_arn = aws_lb_target_group.lb_tgt_group.arn
  target_id        = aws_instance.ec2_autosc.id  #change this!
  port             = 5000

  depends_on = [ aws_autoscaling_group.ecs_asg, aws_launch_configuration.ecs_launch_config]
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.id
  port              = "5000"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_tgt_group.id
    type             = "forward"
  }

  tags = {
    Name = "alb-listener-${local.resource_suffix}"
  }
}