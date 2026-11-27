variable "organization_id" {
  description = "The APM organization's EDA ID, injected by the root module."
  type        = number
}

variable "credentials" {
  description = "EDA credential objects to create, keyed by declaration key."
  type = map(object({
    name            = string
    description     = optional(string)
    credential_type = string
    inputs          = optional(map(string), {})
  }))
  default = {}
}

variable "allowed_types" {
  description = "EDA credential type names sanctioned by the platform."
  type        = set(string)
}

variable "type_ids" {
  description = "EDA credential type IDs resolved by the root module, keyed by declaration key."
  type        = map(number)
  default     = {}
}

variable "permitted_input_ids" {
  description = "Non-secret field IDs from each live EDA credential type, keyed by declaration key."
  type        = map(set(string))
  default     = {}
}
