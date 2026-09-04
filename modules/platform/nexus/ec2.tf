resource "aws_instance" "this" {
  ami = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id = var.private_subnet_ids[0]

  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.nexus.name

  vpc_security_group_ids = [
    aws_security_group.nexus.id
  ]

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    java_version = var.java_version
  })

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
  }

  tags = {
    Name        = var.name
    Application = "Nexus"
    Environment = var.environment
  }
}
