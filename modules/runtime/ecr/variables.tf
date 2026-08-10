variable "environment" {
  type        = string
  description = "Target deployment environment (e.g., test, prod)"
}

variable "repositories" {
  type = map(object({
    image_tag_mutability       = string
    scan_on_push               = bool
    untagged_image_expiry_days = number
    tagged_image_max_count     = number
    tagged_prefixes            = list(string)
  }))
  description = "Map of ECR repositories to create and their specific lifecycle/scanning parameters"
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to append to all repositories"
}
