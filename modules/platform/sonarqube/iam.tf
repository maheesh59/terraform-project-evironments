resource "aws_iam_role" "sonarqube" {
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

  tags = {
    Name    = "${var.name}-role"
    Service = "sonarqube"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.sonarqube.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "secrets" {
  name = "${var.name}-secrets-policy"

  role = aws_iam_role.sonarqube.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = aws_secretsmanager_secret.sonarqube_db.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "sonarqube" {
  name = "${var.name}-instance-profile"

  role = aws_iam_role.sonarqube.name

  tags = {
    Name    = "${var.name}-instance-profile"
    Service = "sonarqube"
  }
}
