variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS Region"
}

variable "project_name" {
  type        = string
  default     = "global-tfstate"
  description = "Project prefix for bootstrap backend resources"
}
