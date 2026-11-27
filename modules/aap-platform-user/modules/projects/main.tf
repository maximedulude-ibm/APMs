resource "aap_project" "this" {
  for_each = var.projects

  name                     = each.value.name
  organization             = var.organization_id
  scm_type                 = each.value.scm_type
  scm_url                  = each.value.scm_url
  scm_branch               = each.value.scm_branch
  scm_update_on_launch     = each.value.scm_update_on_launch
  scm_update_cache_timeout = each.value.scm_update_cache_timeout
  scm_clean                = each.value.scm_clean
  allow_override           = each.value.allow_override
  description              = each.value.description
  timeout                  = each.value.timeout
  credential = each.value.scm_credential == null ? null : (
    each.value.scm_credential == var.platform_scm_credential_key
    ? var.platform_scm_credential_id
    : tonumber(var.credential_ids[each.value.scm_credential])
  )

  lifecycle {
    precondition {
      condition     = each.value.scm_type != "manual"
      error_message = "projects/${each.key}: scm_type must be an SCM-backed source (got \"manual\"). This install refuses manual project uploads, so every job template needs a project with a real scm_url - point it at this repository if the playbook lives here."
    }

    precondition {
      condition     = each.value.scm_credential != var.platform_scm_credential_key || var.platform_scm_credential_id != null
      error_message = "projects/${each.key}: scm_credential = \"${var.platform_scm_credential_key}\" but no platform-managed credential id was supplied to the module. The onboarding tier provides it as the workspace variable aap_platform_scm_credential_id; it is set when the platform actually created the credential."
    }

    precondition {
      condition     = each.value.scm_credential == null || each.value.scm_credential == var.platform_scm_credential_key || contains(keys(var.credential_ids), each.value.scm_credential)
      error_message = "projects/${each.key}: scm_credential \"${coalesce(each.value.scm_credential, "not set")}\" is neither declared in credentials/ nor \"${var.platform_scm_credential_key}\" (the platform-managed credential that can clone this repository). Declare it in credentials/, or use \"${var.platform_scm_credential_key}\"."
    }
  }
}

output "ids" {
  description = "Project IDs, keyed as the input was."
  value       = { for key, project in aap_project.this : key => project.id }
}
