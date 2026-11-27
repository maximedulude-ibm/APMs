variable "organization_name" {
  description = "The one AAP organization this module manages. Resolved to an ID here and injected into every submodule: no submodule accepts an organization of its own, so a consumer cannot name a second one even by mistake. This is the guardrail, not a convention - the credential the consumer runs with is scoped to this single organization on the AAP side."
  type        = string
}

variable "projects" {
  description = "SCM-backed projects, keyed by the key a job template will refer to."
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

variable "eda_projects" {
  description = "EDA projects declared in eda-projects/, keyed by their declaration key."
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
  description = "ID of the platform-managed EDA Source Control credential, selected by EDA projects with scm_credential = \"platform\"."
  type        = number
  default     = null
}

variable "inventories" {
  description = "Inventories, their hosts and their groups, keyed by the key a job template will refer to."
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

variable "credentials" {
  description = "Credential objects (metadata and wiring only - never a secret value), keyed by the key a job template will refer to."
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

variable "eda_credentials" {
  description = "EDA credential objects declared in eda-credentials/, keyed by declaration key. Inputs may contain non-secret fields only."
  type = map(object({
    name            = string
    description     = optional(string)
    credential_type = string
    inputs          = optional(map(string), {})
  }))
  default = {}
}

variable "allowed_eda_credential_types" {
  description = "EDA credential type names this module permits. Defaults to the supported Controller types except Machine; type IDs are resolved from these names in the target AAP installation."
  type        = set(string)
  default = [
    "Source Control",
  ]
}

variable "job_templates" {
  description = "Job templates, keyed by the key a schedule or notification will refer to."
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

variable "job_template_surveys" {
  description = "Survey specs, keyed by the name a job template refers to in its `survey` field."
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

variable "workflow_job_templates" {
  description = "Workflow job templates keyed by workflow key. Use ordered steps for a success chain, or nodes for independent starts. Both reference keys in job_templates. Empty entries are skipped."
  type = map(object({
    name        = string
    description = optional(string)
    nodes       = optional(map(string), {})
    steps = optional(list(object({
      key          = string
      job_template = string
    })), [])
  }))
  default = {}

  validation {
    condition     = alltrue([for workflow in var.workflow_job_templates : length(workflow.nodes) == 0 || length(workflow.steps) == 0])
    error_message = "A workflow must use either nodes (independent starts) or steps (ordered success chain), not both."
  }

  validation {
    condition = alltrue([for workflow in var.workflow_job_templates :
      length(distinct([for step in workflow.steps : step.key])) == length(workflow.steps) &&
      alltrue([for step in workflow.steps : trimspace(step.key) != "" && trimspace(step.job_template) != ""])
    ])
    error_message = "Each workflow step needs a non-empty key and job_template, and step keys must be unique within the workflow."
  }
}

variable "schedules" {
  description = "Scheduled launches, keyed by schedule name."
  type = map(object({
    name                 = string
    description          = optional(string)
    unified_job_template = string
    rrule                = string
    enabled              = optional(bool, true)
    inventory            = optional(string)
    limit                = optional(string)
    extra_data           = optional(map(string), {})
  }))
  default = {}
}

variable "notifications" {
  description = "Notification templates and the job template events they fire on, keyed by notification name."
  type = map(object({
    name              = string
    description       = optional(string)
    notification_type = string
    url               = optional(string)
    configuration     = optional(map(string), {})
    events = optional(map(object({
      started = optional(bool, false)
      success = optional(bool, false)
      error   = optional(bool, false)
    })), {})
  }))
  default = {}
}

variable "platform_scm_credential_id" {
  description = "Existing Controller Source Control credential ID from the bootstrap workspace. Projects select it with scm_credential = platform."
  type        = number
  default     = null
}

variable "allowed_credential_types" {
  description = "Controller credential types allowed in this Vault-free demo, mapped to their AAP kinds."
  type        = map(string)
  default = {
    "Source Control" = "scm"
    "Machine"        = "ssh"
  }
}

variable "allowed_execution_environments" {
  description = "Execution environment names a job template may select. Empty means 'the platform's own default only', which is the safe reading: an EE outside the platform's images is not something a consumer repository should be able to introduce."
  type        = list(string)
  default     = []
}

variable "platform_project_id" {
  description = "Existing Controller project ID owned by the bootstrap workspace; exposed under key platform."
  type        = number
  default     = null
}

variable "platform_inventory_id" {
  description = "Existing inventory ID owned by the bootstrap workspace; exposed under key platform."
  type        = number
  default     = null
}

variable "credential_version_seed" {
  description = "Increase to resend write-only Controller credential inputs after changing them."
  type        = number
  default     = 2
}
