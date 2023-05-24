data "aws_iam_policy_document" "instance_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_role" {
  name_prefix        = "ec2-role-${data.aws_region.current_region.name}-"
  description        = "IAM role for EC2"
  assume_role_policy = data.aws_iam_policy_document.instance_role_policy.json

  tags = {
    Name = "ec2-role-${data.aws_region.current_region.name}"
  }
}

data "aws_iam_policy_document" "secrets_manager_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.instance_role.arn]
    }
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [var.secret_arn]    
  }
}

resource "aws_secretsmanager_secret_policy" "secrets_manager_attachment" {
  secret_arn = var.secret_arn
  policy     = data.aws_iam_policy_document.secrets_manager_role_policy.json
}