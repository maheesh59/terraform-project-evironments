resource "aws_instance" "this" {
  ami = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id = var.private_subnet_ids[0]

  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.sonarqube.name

  vpc_security_group_ids = [
    aws_security_group.sonarqube.id
  ]

  user_data = templatefile("${path.module}/user_data.sh", {
    aws_region        = var.aws_region
    secret_arn        = aws_secretsmanager_secret.sonarqube_db.arn
    sonarqube_version = var.sonarqube_version
    java_version      = var.java_version
  })

  user_data_replace_on_change = true

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
  }

  tags = {
    Name    = var.name
    Service = "sonarqube"
  }

  lifecycle {
    ignore_changes = [
      ami
    ]
  }
}
