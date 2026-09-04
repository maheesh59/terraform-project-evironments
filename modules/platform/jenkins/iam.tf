resource "aws_iam_role" "jenkins" {
  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name}-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.jenkins.name
  policy_arn = var.ssm_policy_arn
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.name}-instance-profile"

  role = aws_iam_role.jenkins.name
}
