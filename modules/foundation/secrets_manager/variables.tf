variable "secrets" {
  description = "Map of Secrets Manager configurations to create."
  type = map(object({
    name                              = string
    description                       = optional(string, "Managed by Terraform")
    kms_key_id                        = optional(string, null)
    recovery_window_in_days           = optional(number, 30)
    secret_string                     = optional(string, null)
    secret_key_values                 = optional(map(string), {})
    policy_json                       = optional(string, null)
    enable_rotation                   = optional(bool, false)
    rotation_lambda_arn               = optional(string, null)
    rotation_automatically_after_days = optional(number, 30)
    tags                              = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "Global tags applied to all secrets created by this module."
  type        = map(string)
  default     = {}
}
