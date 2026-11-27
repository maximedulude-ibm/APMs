locals {
  events = merge([for notif_key, notification in var.notifications : {
    for job_template_key, event in notification.events :
    "${notif_key}.${job_template_key}" => {
      notification_key = notif_key
      job_template_key = job_template_key
      event            = event
    }
  }]...)

  started = { for key, event in local.events : key => event if event.event.started }
  success = { for key, event in local.events : key => event if event.event.success }
  error   = { for key, event in local.events : key => event if event.event.error }
}

resource "aap_notification_template" "this" {
  for_each = var.notifications

  name              = each.value.name
  description       = each.value.description
  notification_type = each.value.notification_type
  organization      = var.organization_id

  notification_configuration = jsonencode(merge(
    each.value.notification_type == "webhook" && try(each.value.configuration.headers, null) == null ? { headers = {} } : {},
    each.value.configuration,
    each.value.url == null ? {} : { url = each.value.url }
  ))
}

resource "aap_job_template_notification_template_started" "this" {
  for_each = local.started

  job_template_id    = var.job_template_ids[each.value.job_template_key]
  notif_template_ids = [tonumber(aap_notification_template.this[each.value.notification_key].id)]

  lifecycle {
    precondition {
      condition     = contains(keys(var.job_template_ids), each.value.job_template_key)
      error_message = "notifications/${each.value.notification_key}: event wiring names job template \"${each.value.job_template_key}\", which is not declared in job-templates/."
    }
  }
}

resource "aap_job_template_notification_template_success" "this" {
  for_each = local.success

  job_template_id    = var.job_template_ids[each.value.job_template_key]
  notif_template_ids = [tonumber(aap_notification_template.this[each.value.notification_key].id)]
}

resource "aap_job_template_notification_template_error" "this" {
  for_each = local.error

  job_template_id    = var.job_template_ids[each.value.job_template_key]
  notif_template_ids = [tonumber(aap_notification_template.this[each.value.notification_key].id)]
}

output "ids" {
  description = "Notification template IDs, keyed as the input was."
  value       = { for key, notification in aap_notification_template.this : key => notification.id }
}
