variable "organization_id" {
  description = "The APM organization's EDA ID, injected by the root module."
  type        = number
}

variable "projects" {
  description = "EDA projects to create, keyed by declaration key."
  type = map(object({
    name           = string
    description    = optional(string)
    scm_type       = optional(string, "git")
    scm_url        = string
    scm_branch     = optional(string, "main")
    scm_credential = optional(string)
  }))
  default = {}
}

variable "platform_eda_scm_credential_id" {
  description = "ID of the platform-managed EDA Source Control credential."
  type        = number
  default     = null
}

variable "credential_ids" {
  description = "EDA credential IDs keyed by eda-credentials/ declaration key."
  type        = map(string)
  default     = {}
}
