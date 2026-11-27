variable "organization_id" {
  description = "The single organization every credential belongs to. Injected by the root module."
  type        = string
}

variable "credentials" {
  description = "Credential objects to create, keyed by the key a job template refers to."
  type = map(object({
    name                 = string
    description          = optional(string)
    credential_type      = string
    credential_type_kind = optional(string)
    credential_type_id   = optional(number)
    inputs               = optional(map(string), {})
  }))
  default = {}
}

variable "type_ids" {
  description = "Resolved credential type IDs, keyed by credential key (the root module looks them up, because IDs are per-install)."
  type        = map(number)
  default     = {}
}

variable "credential_version_seed" {
  description = "Version for the write-only inputs. Changing a credential's inputs without changing this is a silent no-op, so pass something that moves when a credential must be re-sent."
  type        = number
  default     = 1
}

variable "allowed_types" {
  description = "Sanctioned credential types, as name => the AAP kind that name lives under. A type outside this map is refused by name."
  type        = map(string)
}
