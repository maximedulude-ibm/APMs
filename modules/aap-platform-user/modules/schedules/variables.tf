variable "schedules" {
  description = "Scheduled launches, keyed by schedule key."
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

variable "job_template_ids" {
  description = "Job template IDs keyed by job template key, for the template a schedule launches."
  type        = map(string)
  default     = {}
}

variable "inventory_ids" {
  description = "Inventory IDs keyed by inventory key, for schedules that prompt an inventory."
  type        = map(string)
  default     = {}
}
