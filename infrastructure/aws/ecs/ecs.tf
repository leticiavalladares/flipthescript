resource "aws_ecr_repository" "ecr_repo" {
  name                 = "flipthescript"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "flipthescript-${local.resource_suffix}" #change name is too redundant
  }
}

#----- TASK FOR EC2 -----
# resource "aws_ecs_task_definition" "task_def" {
#   family             = "flipthescript-definition"
#   execution_role_arn = aws_iam_role.ecs_role.arn
#   task_role_arn      = aws_iam_role.ecs_role.arn
#   container_definitions = jsonencode([
#     {
#       name      = "flipthescript"
#       image     = "653363876120.dkr.ecr.eu-central-1.amazonaws.com/flipthescript"
#       cpu       = 10
#       memory    = 128
#       essential = true
#       portMappings = [
#         {
#           containerPort = 5000
#           hostPort      = 5000
#         }
#       ]
#     }
#   ])
# }

resource "aws_ecs_task_definition" "task_def" {
  family                   = "flipthescript-definition"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_role.arn
  #task_role_arn            = aws_iam_role.ecs_role.arn
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = jsonencode([
    {
      name      = "flipthescript"
      image     = "653363876120.dkr.ecr.eu-central-1.amazonaws.com/flipthescript"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "cluster-${local.resource_suffix}"

  tags = {
    Name = "cluster-${local.resource_suffix}"
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = "service-${local.resource_suffix}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"   #"EC2"

  network_configuration {
    assign_public_ip = true
    security_groups = [aws_security_group.task_sg.id]
    subnets         = [for item in local.private_snets: aws_subnet.subnet[item].id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb_tgt_group.id
    container_name   = "flipthescript"
    container_port   = 5000
  }

  tags = {
    Name = "service-${local.resource_suffix}"
  }
}