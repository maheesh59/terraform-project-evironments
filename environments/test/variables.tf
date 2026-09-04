variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "public_subnet_azs" {
  type = list(string)
}

variable "private_subnet_azs" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "vpc_endpoints" {
  type = object({
    enable_s3             = bool
    enable_dynamodb       = bool
    enable_ecr            = bool
    enable_secretsmanager = bool
    enable_ssm            = bool
    enable_ssmmessages    = bool
    enable_ec2messages    = bool
    name_prefix           = string
  })
}

variable "ecr" {
  type = object({
    repositories = any
  })
}

variable "eks" {
  type = object({
    cluster_name               = string
    cluster_version            = string
    cluster_log_retention_days = number
    node_groups                = any
    eks_addons                 = any
  })
}

variable "rds" {
  sensitive = true

  type = object({
    allowed_cidr_blocks                = list(string)
    security_group_description         = string
    security_group_ingress_description = string
    cidr_ingress_description           = string
    ingress_protocol                   = string
    egress_cidr                        = string
    egress_protocol                    = string
    egress_description                 = string

    engine                 = string
    engine_version         = string
    parameter_group_family = string
    instance_class         = string

    db_name  = string
    username = string
    port     = number
    password = string

    allocated_storage     = number
    max_allocated_storage = number
    storage_type          = string
    storage_encrypted     = bool

    kms_key_arn                 = string
    secrets_manager_kms_key_arn = string

    kms_deletion_window_in_days    = number
    kms_enable_key_rotation        = bool
    secret_recovery_window_in_days = number

    publicly_accessible = bool
    multi_az            = bool

    backup_retention_period = number
    backup_window           = string
    maintenance_window      = string
    copy_tags_to_snapshot   = bool

    deletion_protection             = bool
    skip_final_snapshot             = bool
    monitoring_interval             = number
    enabled_cloudwatch_logs_exports = list(string)

    parameters = any
  })
}

variable "load_balancer_controller" {
  type = object({
    enabled         = bool
    replica_count   = number
    chart_version   = string
    enable_waf      = bool
    enable_wafv2    = bool
    enable_shield   = bool
    namespace       = string
    service_account = string
  })
}

variable "platform" {
  type = object({
    enable_jenkins   = bool
    enable_nexus     = bool
    enable_sonarqube = bool

    target_type          = string
    listener_action_type = string

    alb = object({
      name                = string
      internal            = bool
      load_balancer_type  = string
      deletion_protection = bool

      security_group_name        = string
      security_group_description = string

      ingress_rules = map(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      }))

      egress = object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      })
    })

    jenkins = object({
      name                        = string
      ami_id                      = string
      ami_most_recent             = bool
      ami_owner                   = string
      ami_name_pattern            = string
      ami_architecture            = string
      ami_root_device_type        = string
      instance_type               = string
      root_volume_size            = number
      root_volume_type            = string
      root_volume_encrypted       = bool
      associate_public_ip_address = bool

      port         = number
      protocol     = string
      java_version = number

      listener_port     = number
      listener_protocol = string

      target_group_name     = string
      target_group_protocol = string

      security_group_description = string
      ingress_description        = string

      egress_description = string
      egress_from_port   = number
      egress_to_port     = number
      egress_protocol    = string
      egress_cidr_blocks = list(string)

      ssm_policy_arn = string

      health_check = object({
        enabled             = bool
        protocol            = string
        path                = string
        matcher             = string
        interval            = number
        timeout             = number
        healthy_threshold   = number
        unhealthy_threshold = number
      })
    })

    nexus = object({
      name             = string
      ami_id           = optional(string, null)
      instance_type    = string
      root_volume_size = number
      java_version     = string

      listener_port     = number
      listener_protocol = string

      port = number

      target_group_name     = string
      target_group_protocol = string

      health_check = object({
        enabled             = bool
        protocol            = string
        path                = string
        matcher             = string
        interval            = number
        timeout             = number
        healthy_threshold   = number
        unhealthy_threshold = number
      })
    })

    sonarqube = object({
      name             = string
      instance_type    = string
      root_volume_size = number
      ami_id           = optional(string, null)

      sonarqube_version = string
      java_version      = number

      database_name     = string
      database_username = string
      database_password = string
      database_port     = number

      listener_port         = number
      listener_protocol     = string
      port                  = number
      target_group_name     = string
      target_group_protocol = string

      health_check = object({
        enabled             = bool
        protocol            = string
        path                = string
        matcher             = string
        interval            = number
        timeout             = number
        healthy_threshold   = number
        unhealthy_threshold = number
      })
    })
  })
}


