resource "aap_schedule" "this" {
  for_each = var.schedules

  name        = each.value.name
  description = each.value.description

  unified_job_template = tonumber(var.job_template_ids[each.value.unified_job_template])
  rrule                = each.value.rrule
  enabled              = each.value.enabled

  inventory  = each.value.inventory == null ? null : tonumber(var.inventory_ids[each.value.inventory])
  limit      = each.value.limit
  extra_data = length(each.value.extra_data) > 0 ? each.value.extra_data : null

  lifecycle {
    precondition {
      condition     = contains(keys(var.job_template_ids), each.value.unified_job_template)
      error_message = "schedules/${each.key}: unified_job_template \"${each.value.unified_job_template}\" is not declared in job-templates/. A schedule cannot launch a job template this module does not own - it would outlive its own deletion."
    }

    precondition {
      condition     = each.value.inventory == null || contains(keys(var.inventory_ids), each.value.inventory)
      error_message = "schedules/${each.key}: inventory \"${coalesce(each.value.inventory, "not set")}\" is not declared in inventories/."
    }
  }
}

output "ids" {
  description = "Schedule IDs, keyed as the input was."
  value       = { for key, schedule in aap_schedule.this : key => schedule.id }
}
