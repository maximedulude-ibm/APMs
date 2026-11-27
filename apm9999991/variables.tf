variable "aap_endpoint" {
  description = "Giolab AAP gateway URL, including https://."
  type        = string
}

variable "aap_username" {
  description = "APM organization administrator created by the bootstrap workspace."
  type        = string
}

variable "aap_password" {
  description = "Password for the APM organization administrator. Set as a sensitive HCP variable."
  type        = string
  sensitive   = true
}

variable "aap_insecure_skip_verify" {
  description = "Giolab demo only; install the AAP CA on the agent for verified TLS."
  type        = bool
  default     = false
}

variable "platform_scm_credential_id" {
  description = "Controller SCM credential ID from the bootstrap workspace output."
  type        = number
  default     = null
}

variable "platform_eda_scm_credential_id" {
  description = "EDA SCM credential ID from the bootstrap workspace output."
  type        = number
  default     = null
}

variable "platform_project_id" {
  description = "Controller project ID from the bootstrap workspace output; referenced as project: platform."
  type        = number
  default     = null
}

variable "platform_inventory_id" {
  description = "Inventory ID from the bootstrap workspace output; referenced as inventory: platform."
  type        = number
  default     = null
}

variable "credential_version_seed" {
  description = "Increase to resend updated write-only credential inputs to AAP."
  type        = number
  default     = 2
}
