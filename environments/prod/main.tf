module "vpc" {
  source = "../../modules/foundation/vpc"

  environment          = var.environment
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_azs    = var.public_subnet_azs
  private_subnet_azs   = var.private_subnet_azs
}

module "vpc_endpoints" {
  source = "../../modules/foundation/vpc_endpoints"

  environment = var.environment
  aws_region  = var.aws_region

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr

  private_subnet_ids      = module.vpc.private_subnet_ids
  private_route_table_ids = module.vpc.private_route_table_ids

  enable_s3_endpoint             = var.vpc_endpoints.enable_s3
  enable_dynamodb_endpoint       = var.vpc_endpoints.enable_dynamodb
  enable_ecr_endpoints           = var.vpc_endpoints.enable_ecr
  enable_secretsmanager_endpoint = var.vpc_endpoints.enable_secretsmanager
  enable_ssm_endpoint            = var.vpc_endpoints.enable_ssm
  enable_ssmmessages_endpoint    = var.vpc_endpoints.enable_ssmmessages
  enable_ec2messages_endpoint    = var.vpc_endpoints.enable_ec2messages

  name_prefix = var.vpc_endpoints.name_prefix

  common_tags = var.tags
}

module "ecr" {
  source = "../../modules/runtime/ecr"

  environment  = var.environment
  repositories = var.ecr.repositories
  extra_tags   = var.tags
}

module "eks" {
  source = "../../modules/runtime/eks"

  environment                = var.environment
  cluster_name               = var.eks.cluster_name
  cluster_version            = var.eks.cluster_version
  cluster_log_retention_days = var.eks.cluster_log_retention_days

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  node_groups = var.eks.node_groups
  eks_addons = var.eks.eks_addons

  extra_tags = var.tags
}

module "rds" {
  source = "../../modules/runtime/rds"

  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  allowed_security_group_ids = {
    eks_nodes = module.eks.node_security_group_id
  }

  allowed_cidr_blocks                = var.rds.allowed_cidr_blocks
  security_group_description         = var.rds.security_group_description
  security_group_ingress_description = var.rds.security_group_ingress_description
  cidr_ingress_description           = var.rds.cidr_ingress_description
  ingress_protocol                   = var.rds.ingress_protocol
  egress_cidr_block                  = var.rds.egress_cidr
  egress_protocol                    = var.rds.egress_protocol
  egress_description                 = var.rds.egress_description

  engine         = var.rds.engine
  engine_version = var.rds.engine_version
  family         = var.rds.parameter_group_family
  instance_class = var.rds.instance_class

  db_name  = var.rds.db_name
  username = var.rds.username
  port     = var.rds.port
  password = var.rds.password

  allocated_storage     = var.rds.allocated_storage
  max_allocated_storage = var.rds.max_allocated_storage
  storage_type          = var.rds.storage_type
  storage_encrypted     = var.rds.storage_encrypted

  kms_key_arn                    = var.rds.kms_key_arn
  secrets_manager_kms_key_arn    = var.rds.secrets_manager_kms_key_arn
  kms_deletion_window_in_days    = var.rds.kms_deletion_window_in_days
  kms_enable_key_rotation        = var.rds.kms_enable_key_rotation
  secret_recovery_window_in_days = var.rds.secret_recovery_window_in_days

  publicly_accessible          = var.rds.publicly_accessible
  multi_az                     = var.rds.multi_az
  backup_retention_period      = var.rds.backup_retention_period
  preferred_backup_window      = var.rds.backup_window
  preferred_maintenance_window = var.rds.maintenance_window
  copy_tags_to_snapshot        = var.rds.copy_tags_to_snapshot

  deletion_protection             = var.rds.deletion_protection
  skip_final_snapshot             = var.rds.skip_final_snapshot
  monitoring_interval             = var.rds.monitoring_interval
  enabled_cloudwatch_logs_exports = var.rds.enabled_cloudwatch_logs_exports
  parameters                      = var.rds.parameters
}

module "load_balancer_controller" {
  source = "../../modules/runtime/load-balancer-controller"

  aws_region   = var.aws_region
  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id

  cluster_name = module.eks.cluster_name

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url

  enable_aws_load_balancer_controller = (
    var.load_balancer_controller.enabled
  )

  lb_controller_replica_count = (
    var.load_balancer_controller.replica_count
  )

  lb_controller_chart_version = (
    var.load_balancer_controller.chart_version
  )

  enable_waf    = var.load_balancer_controller.enable_waf
  enable_wafv2  = var.load_balancer_controller.enable_wafv2
  enable_shield = var.load_balancer_controller.enable_shield

  lb_controller_namespace = (
    var.load_balancer_controller.namespace
  )

  lb_controller_service_account = (
    var.load_balancer_controller.service_account
  )

  additional_tags = var.tags
}

module "platform" {
  source = "../../modules/platform/alb"

  environment  = var.environment
  project_name = var.project_name
  aws_region   = var.aws_region

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  enable_jenkins   = var.platform.enable_jenkins
  enable_nexus     = var.platform.enable_nexus
  enable_sonarqube = var.platform.enable_sonarqube

  alb_name                = var.platform.alb.name
  alb_internal            = var.platform.alb.internal
  alb_load_balancer_type  = var.platform.alb.load_balancer_type
  alb_deletion_protection = var.platform.alb.deletion_protection

  alb_security_group_name        = var.platform.alb.security_group_name
  alb_security_group_description = var.platform.alb.security_group_description

  alb_ingress_rules = var.platform.alb.ingress_rules

  alb_egress_description = var.platform.alb.egress.description
  alb_egress_from_port   = var.platform.alb.egress.from_port
  alb_egress_to_port     = var.platform.alb.egress.to_port
  alb_egress_protocol    = var.platform.alb.egress.protocol
  alb_egress_cidr_blocks = var.platform.alb.egress.cidr_blocks

  target_type           = var.platform.target_type
  listener_action_type  = var.platform.listener_action_type

  jenkins_listener_port     = var.platform.jenkins.listener_port
  jenkins_listener_protocol = var.platform.jenkins.listener_protocol

  nexus_listener_port     = var.platform.nexus.listener_port
  nexus_listener_protocol = var.platform.nexus.listener_protocol

  sonarqube_listener_port     = var.platform.sonarqube.listener_port
  sonarqube_listener_protocol = var.platform.sonarqube.listener_protocol

  jenkins_port   = var.platform.jenkins.port
  nexus_port     = var.platform.nexus.port
  sonarqube_port = var.platform.sonarqube.port

  jenkins_target_group_name   = var.platform.jenkins.target_group_name
  nexus_target_group_name     = var.platform.nexus.target_group_name
  sonarqube_target_group_name = var.platform.sonarqube.target_group_name

  jenkins_target_group_protocol   = var.platform.jenkins.target_group_protocol
  nexus_target_group_protocol     = var.platform.nexus.target_group_protocol
  sonarqube_target_group_protocol = var.platform.sonarqube.target_group_protocol

  jenkins_health_check   = var.platform.jenkins.health_check
  nexus_health_check     = var.platform.nexus.health_check
  sonarqube_health_check = var.platform.sonarqube.health_check

  jenkins   = var.platform.jenkins
  nexus     = var.platform.nexus
  sonarqube = var.platform.sonarqube

  common_tags = var.tags
}
