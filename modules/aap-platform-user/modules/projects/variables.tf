variable "organization_id" {
  description = "The single organization every project is created in. Injected by the root module - never a consumer input."
  type        = string
}

variable "projects" {
  description = "Projects to create, keyed by the key a job template refers to."
  type = map(object({
    name                     = string
    description              = optional(string)
    scm_type                 = optional(string, "git")
    scm_url                  = string
    scm_branch               = optional(string, "main")
    scm_update_on_launch     = optional(bool, true)
    scm_update_cache_timeout = optional(number)
    scm_clean                = optional(bool, false)
    allow_override           = optional(bool, false)
    scm_credential           = optional(string)
    timeout                  = optional(number, 0)
  }))
  default = {}
}

variable "credential_ids" {
  description = "Credential IDs keyed by credential key, for projects that name a Source Control credential."
  type        = map(string)
  default     = {}
}

variable "platform_scm_credential_id" {
  description = "Numeric id of the platform-managed Source Control credential for this APM's repository, selected with scm_credential = \"platform\". Null when the platform did not provide one."
  type        = number
  default     = null
}

variable "platform_scm_credential_key" {
  description = "The key a project uses to select the platform-managed credential, rather than one of its own."
  type        = string
  default     = "platform"
}
