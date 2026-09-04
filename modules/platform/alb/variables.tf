variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "enable_jenkins" {
  type = bool
}

variable "enable_nexus" {
  type = bool
}

variable "enable_sonarqube" {
  type = bool
}

variable "alb_name" {
  type = string
}

variable "alb_internal" {
  type = bool
}

variable "alb_load_balancer_type" {
  type = string
}

variable "alb_deletion_protection" {
  type = bool
}

variable "alb_security_group_name" {
  type = string
}

variable "alb_security_group_description" {
  type = string
}

variable "alb_ingress_rules" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "alb_egress_description" {
  type = string
}

variable "alb_egress_from_port" {
  type = number
}

variable "alb_egress_to_port" {
  type = number
}

variable "alb_egress_protocol" {
  type = string
}

variable "alb_egress_cidr_blocks" {
  type = list(string)
}

variable "target_type" {
  type = string
}

variable "listener_action_type" {
  type = string
}

variable "jenkins_listener_port" {
  type = number
}

variable "jenkins_listener_protocol" {
  type = string
}

variable "nexus_listener_port" {
  type = number
}

variable "nexus_listener_protocol" {
  type = string
}

variable "sonarqube_listener_port" {
  type = number
}

variable "sonarqube_listener_protocol" {
  type = string
}

variable "jenkins_port" {
  type = number
}

variable "nexus_port" {
  type = number
}

variable "sonarqube_port" {
  type = number
}

variable "jenkins_target_group_name" {
  type = string
}

variable "nexus_target_group_name" {
  type = string
}

variable "sonarqube_target_group_name" {
  type = string
}

variable "jenkins_target_group_protocol" {
  type = string
}

variable "nexus_target_group_protocol" {
  type = string
}

variable "sonarqube_target_group_protocol" {
  type = string
}

variable "jenkins_health_check" {
  type = object({
    enabled             = bool
    protocol            = string
    path                = string
    matcher             = string
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  })
}

variable "nexus_health_check" {
  type = object({
    enabled             = bool
    protocol            = string
    path                = string
    matcher             = string
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  })
}

variable "sonarqube_health_check" {
  type = object({
    enabled             = bool
    protocol            = string
    path                = string
    matcher             = string
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  })
}

variable "jenkins" {
  type = object({
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
    port                        = number
    protocol                    = string

    java_version = number

    security_group_description = string
    ingress_description        = string
    egress_description         = string
    egress_from_port           = number
    egress_to_port             = number
    egress_protocol            = string
    egress_cidr_blocks         = list(string)
    ssm_policy_arn             = string
  })
}


variable "nexus_name" {
  description = "Nexus instance name"
  type        = string
}

variable "nexus_java_version" {
  description = "Java version for Nexus"
  type        = string
}

variable "nexus_instance_type" {
  description = "Nexus EC2 instance type"
  type        = string
}

variable "nexus_root_volume_size" {
  description = "Nexus root volume size"
  type        = number
}

variable "nexus_ami_id" {
  description = "Nexus AMI ID"
  type        = string
  default     = null
}

variable "sonarqube" {
  description = "SonarQube configuration"

  type = object({
    name              = string
    instance_type     = string
    root_volume_size  = number
    ami_id            = optional(string, null)

    sonarqube_version = string
    java_version      = number

    database_name     = string
    database_username = string
    database_password = string
    database_port     = number
  })
}

variable "common_tags" {
  type = map(string)
}
