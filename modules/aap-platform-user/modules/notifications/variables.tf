variable "organization_id" {
  description = "The single organization every notification template belongs to. Injected by the root module."
  type        = string
}

variable "notifications" {
  description = "Notification templates and the job template events they fire on, keyed by notification key."
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

variable "job_template_ids" {
  description = "Job template IDs keyed by job template key, for the event wiring."
  type        = map(string)
  default     = {}
}
