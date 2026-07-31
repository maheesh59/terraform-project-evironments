variable "environment" {
  type        = string
  description = "Deployment environment name (e.g., test, prod)"
}

variable "description" {
  type        = string
  description = "Description of the KMS key"
  default     = "Customer Managed Key (CMK) for infrastructure encryption"
}

variable "alias_name" {
  type        = string
  description = "Display alias for the key (e.g. app-encryption-key)"
  default     = null
}

variable "deletion_window_in_days" {
  type        = number
  description = "Waiting period before key deletion (7 to 30 days)"
  default     = 30
}

variable "enable_key_rotation" {
  type        = bool
  description = "Specifies whether automatic annual key rotation is enabled"
  default     = true
}

variable "is_enabled" {
  type        = bool
  description = "Specifies whether the key is enabled"
  default     = true
}

variable "key_usage" {
  type        = string
  description = "Intended key usage (ENCRYPT_DECRYPT or SIGN_VERIFY)"
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  type        = string
  description = "Specifies symmetric or asymmetric key spec"
  default     = "SYMMETRIC_DEFAULT"
}

variable "key_administrators" {
  type        = list(string)
  description = "List of IAM ARNs permitted to administer the key"
  default     = []
}

variable "key_users" {
  type        = list(string)
  description = "List of IAM ARNs permitted to use the key for encryption/decryption"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Map of additional tags"
  default     = {}
}
