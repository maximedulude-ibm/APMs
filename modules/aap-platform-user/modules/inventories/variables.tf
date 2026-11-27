variable "organization_id" {
  description = "The single organization every inventory is created in. Injected by the root module."
  type        = string
}

variable "inventories" {
  description = "Inventories with their hosts and groups, keyed by the key a job template refers to."
  type = map(object({
    name        = string
    description = optional(string)
    variables   = optional(string)
    hosts = optional(map(object({
      description = optional(string)
      enabled     = optional(bool, true)
      variables   = optional(string)
    })), {})
    groups = optional(map(object({
      description = optional(string)
      variables   = optional(string)
      hosts       = optional(list(string), [])
    })), {})
  }))
  default = {}
}
