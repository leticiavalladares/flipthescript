data "aws_iam_policy_document" "ecs_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_role" {
  name_prefix        = "ecs-role-${data.aws_region.current_region.name}-"
  description        = "IAM role for ECS"
  assume_role_policy = data.aws_iam_policy_document.ecs_role_policy.json

  tags = {
    Name = "ecs-role-${data.aws_region.current_region.name}"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_role_pol_att" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
