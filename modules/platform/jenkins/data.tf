data "aws_ami" "amazon_linux" {
  most_recent = var.ami_most_recent

  owners = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  filter {
    name   = "architecture"
    values = [var.ami_architecture]
  }

  filter {
    name   = "root-device-type"
    values = [var.ami_root_device_type]
  }
}
