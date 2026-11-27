variable "organization_id" {
  description = "The single organization every workflow job template belongs to. Injected by the root module."
  type        = string
}

variable "workflow_job_templates" {
  description = "Workflow job templates keyed by workflow key. Use ordered steps for a success chain, or nodes for independent starts. Both reference keys in job_template_ids."
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

variable "job_template_ids" {
  description = "Managed job template IDs keyed by the job_templates input key."
  type        = map(string)
  default     = {}
}
