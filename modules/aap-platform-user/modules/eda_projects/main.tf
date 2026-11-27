resource "aap_eda_project" "this" {
  for_each = var.projects

  name            = each.value.name
  description     = each.value.description
  organization_id = var.organization_id
  scm_type        = each.value.scm_type
  url             = each.value.scm_url
  scm_branch      = each.value.scm_branch
  eda_credential_id = each.value.scm_credential == null ? null : (
    each.value.scm_credential == "platform"
    ? var.platform_eda_scm_credential_id
    : try(tonumber(var.credential_ids[each.value.scm_credential]), null)
  )

  lifecycle {
    precondition {
      condition     = each.value.scm_credential != "platform" || var.platform_eda_scm_credential_id != null
      error_message = "eda-projects/${each.key}: scm_credential = \"platform\" requires the platform EDA Source Control credential ID."
    }

    precondition {
      condition     = each.value.scm_credential == null || each.value.scm_credential == "platform" || contains(keys(var.credential_ids), each.value.scm_credential)
      error_message = "eda-projects/${each.key}: scm_credential must be \"platform\", omitted, or a key declared in eda-credentials/."
    }
  }
}

output "ids" {
  description = "EDA project IDs keyed by declaration key."
  value       = { for key, project in aap_eda_project.this : key => project.id }
}
