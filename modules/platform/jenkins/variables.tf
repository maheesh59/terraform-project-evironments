variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "root_volume_size" {
  type = number
}

variable "root_volume_type" {
  type = string
}

variable "root_volume_encrypted" {
  type = bool
}

variable "associate_public_ip_address" {
  type = bool
}

variable "application_port" {
  type = number
}

variable "application_protocol" {
  type = string
}

variable "security_group_description" {
  type = string
}

variable "ingress_description" {
  type = string
}

variable "egress_description" {
  type = string
}

variable "egress_from_port" {
  type = number
}

variable "egress_to_port" {
  type = number
}

variable "egress_protocol" {
  type = string
}

variable "egress_cidr_blocks" {
  type = list(string)
}

variable "ami_id" {
  description = "Optional custom AMI ID. If null, the latest matching AMI is selected."
  type        = string
  default     = null
}

variable "ami_most_recent" {
  type = bool
}

variable "ami_owner" {
  type = string
}

variable "ami_name_pattern" {
  type = string
}

variable "ami_architecture" {
  type = string
}

variable "ami_root_device_type" {
  type = string
}

variable "ssm_policy_arn" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "java_version" {
  description = "Java version required by Jenkins"
  type        = string
}
