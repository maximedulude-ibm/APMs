variable "organization_id" {
  description = "The single organization every job template lives in. Injected by the root module."
  type        = string
}

variable "job_templates" {
  description = "Job templates to create, keyed by the key a schedule or notification refers to."
  type = map(object({
    name                  = string
    description           = optional(string)
    job_type              = optional(string, "run")
    project               = string
    playbook              = string
    inventory             = optional(string)
    credentials           = optional(list(string), [])
    execution_environment = optional(string)
    limit                 = optional(string)
    forks                 = optional(number)
    timeout               = optional(number, 0)
    verbosity             = optional(number, 0)
    allow_simultaneous    = optional(bool, false)
    extra_vars            = optional(string)
    survey                = optional(string)

  }))
  default = {}
}

variable "surveys" {
  description = "Survey specs keyed by the name a job template refers to."
  type = map(object({
    name        = string
    description = optional(string)
    spec = list(object({
      question_name        = string
      variable             = string
      type                 = string
      question_description = optional(string, "")
      choices              = optional(list(string))
      default              = optional(string)
      min                  = optional(number)
      max                  = optional(number)
      required             = optional(bool, false)
    }))
  }))
  default = {}
}

variable "project_ids" {
  description = "Project IDs keyed by project key."
  type        = map(string)
  default     = {}
}

variable "inventory_ids" {
  description = "Inventory IDs keyed by inventory key."
  type        = map(string)
  default     = {}
}

variable "credential_ids" {
  description = "Credential IDs keyed by credential key."
  type        = map(string)
  default     = {}
}

variable "execution_environment_ids" {
  description = "Execution environment IDs keyed by job template key, for templates whose EE was resolved by the root module."
  type        = map(number)
  default     = {}
}

variable "allowed_execution_environments" {
  description = "Execution environment names a template may select. Empty means the platform default only."
  type        = list(string)
  default     = []
}
