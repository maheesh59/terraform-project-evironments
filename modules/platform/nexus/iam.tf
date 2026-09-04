resource "aws_iam_role" "nexus" {
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
    Name        = "${var.name}-role"
    Application = "Nexus"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "nexus_ssm" {
  role       = aws_iam_role.nexus.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "nexus" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.nexus.name

  tags = {
    Name        = "${var.name}-instance-profile"
    Application = "Nexus"
    Environment = var.environment
  }
}
