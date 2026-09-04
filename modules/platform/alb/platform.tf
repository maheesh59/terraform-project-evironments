module "jenkins" {
  count  = var.enable_jenkins ? 1 : 0
  source = "../jenkins"

  name = var.jenkins.name

  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids

  alb_security_group_id = aws_security_group.alb.id

  ami_id            = var.jenkins.ami_id
  ami_most_recent   = var.jenkins.ami_most_recent
  ami_owner         = var.jenkins.ami_owner
  ami_name_pattern  = var.jenkins.ami_name_pattern
  ami_architecture  = var.jenkins.ami_architecture
  ami_root_device_type = var.jenkins.ami_root_device_type

  instance_type          = var.jenkins.instance_type
  root_volume_size       = var.jenkins.root_volume_size
  root_volume_type       = var.jenkins.root_volume_type
  root_volume_encrypted  = var.jenkins.root_volume_encrypted
    
  associate_public_ip_address = var.jenkins.associate_public_ip_address

  application_port    = var.jenkins.port
  application_protocol = var.jenkins.protocol
  
  java_version = var.jenkins.java_version

  security_group_description = var.jenkins.security_group_description
  ingress_description        = var.jenkins.ingress_description

  egress_description = var.jenkins.egress_description
  egress_from_port   = var.jenkins.egress_from_port
  egress_to_port     = var.jenkins.egress_to_port
  egress_protocol    = var.jenkins.egress_protocol
  egress_cidr_blocks = var.jenkins.egress_cidr_blocks

  ssm_policy_arn = var.jenkins.ssm_policy_arn

  common_tags = var.common_tags
}

module "nexus" {
  count  = var.enable_nexus ? 1 : 0
  source = "../nexus"

  name = var.nexus_name

  environment = var.environment

  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids

  alb_security_group_id = aws_security_group.alb.id

  ami_id          = var.nexus_ami_id
  instance_type   = var.nexus_instance_type
  root_volume_size = var.nexus_root_volume_size

  java_version = var.nexus_java_version

  nexus_port = var.nexus_port
}

module "sonarqube" {
  count  = var.enable_sonarqube ? 1 : 0
  source = "../sonarqube"

  name = var.sonarqube.name

  aws_region = var.aws_region

  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids

  alb_security_group_id = aws_security_group.alb.id

  instance_type    = var.sonarqube.instance_type
  root_volume_size = var.sonarqube.root_volume_size

  ami_id = var.sonarqube.ami_id

  sonarqube_version = var.sonarqube.sonarqube_version
  java_version      = var.sonarqube.java_version

  database_name     = var.sonarqube.database_name
  database_username = var.sonarqube.database_username
  database_password = var.sonarqube.database_password
  database_port     = var.sonarqube.database_port
}
