variable "buckets" {
  description = "Map of S3 bucket configurations to create."
  type = map(object({
    bucket_name                       = string
    force_destroy                     = optional(bool, false)
    enable_versioning                 = optional(bool, true)
    kms_key_arn                       = optional(string, null)
    block_public_access               = optional(bool, true)
    enable_lifecycle_rules            = optional(bool, false)
    lifecycle_transition_ia_days      = optional(number, 30)
    lifecycle_transition_glacier_days = optional(number, null)
    lifecycle_noncurrent_expiration_days = optional(number, 90)
    bucket_policy_json                = optional(string, null)
    cors_rules                        = optional(list(any), [])
    tags                              = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "Global default tags applied to all buckets created by this module."
  type        = map(string)
  default     = {}
}
