resource "aws_ecr_repository" "ecr_repo" {
  name                 = "flipthescript"
  image_tag_mutability = "MUTABLE"  

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "flipthescript-${local.resource_suffix}"
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family                = "flipthescript-definition"
  execution_role_arn    = aws_iam_role.ecs_role.arn
  task_role_arn         = aws_iam_role.ecs_role.arn
  container_definitions = jsonencode([
    {
      name      = "flipthescript"
      image     = "653363876120.dkr.ecr.eu-central-1.amazonaws.com/flipthescript"
      cpu       = 10
      memory    = 128
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
    }
  ])
}
