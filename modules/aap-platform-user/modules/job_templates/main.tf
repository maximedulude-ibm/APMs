resource "aap_job_template" "this" {
  for_each = var.job_templates

  name        = each.value.name
  description = each.value.description
  job_type    = each.value.job_type

  project  = tonumber(var.project_ids[each.value.project])
  playbook = each.value.playbook

  inventory = each.value.inventory == null ? null : tonumber(var.inventory_ids[each.value.inventory])

  execution_environment = each.value.execution_environment == null ? null : var.execution_environment_ids[each.key]

  limit              = each.value.limit
  forks              = each.value.forks
  timeout            = each.value.timeout
  verbosity          = each.value.verbosity
  allow_simultaneous = each.value.allow_simultaneous
  extra_vars         = each.value.extra_vars

  survey_enabled = each.value.survey != null

  lifecycle {
    precondition {
      condition     = contains(["run", "check"], each.value.job_type)
      error_message = "job-templates/${each.key}: job_type must be \"run\" or \"check\" (got \"${each.value.job_type}\"). Declare workflow job templates through workflow_job_templates instead."
    }

    precondition {
      condition     = contains(keys(var.project_ids), each.value.project)
      error_message = "job-templates/${each.key}: project \"${each.value.project}\" is neither declared in projects/ nor the bootstrap project key platform."
    }

    precondition {
      condition     = each.value.inventory == null || contains(keys(var.inventory_ids), each.value.inventory)
      error_message = "job-templates/${each.key}: inventory \"${coalesce(each.value.inventory, "not set")}\" is neither declared in inventories/ nor the bootstrap inventory key platform."
    }

    precondition {
      condition     = alltrue([for key in each.value.credentials : contains(keys(var.credential_ids), key)])
      error_message = "job-templates/${each.key}: one or more credentials are not declared in credentials/. Declare each one there first - a credential that does not exist cannot be attached."
    }

    precondition {
      condition     = each.value.survey == null || contains(keys(var.surveys), each.value.survey)
      error_message = "job-templates/${each.key}: survey \"${coalesce(each.value.survey, "not set")}\" is not declared in job-template-surveys/. The survey is referenced by its file name."
    }

    precondition {
      condition     = each.value.execution_environment == null || contains(var.allowed_execution_environments, each.value.execution_environment)
      error_message = "job-templates/${each.key}: execution environment \"${coalesce(each.value.execution_environment, "not set")}\" is not on the platform's allowed list (${length(var.allowed_execution_environments) == 0 ? "currently empty, meaning the platform default only" : join(", ", var.allowed_execution_environments)}). Requesting a new execution environment is a platform request."
    }


  }
}

resource "aap_job_template_credential" "this" {
  for_each = { for key, template in var.job_templates : key => template if length(template.credentials) > 0 }

  job_template_id = aap_job_template.this[each.key].id
  credential_ids  = [for key in each.value.credentials : tonumber(var.credential_ids[key])]
}

resource "aap_job_template_survey_spec" "this" {
  for_each = { for key, template in var.job_templates : key => template if template.survey != null }

  id          = aap_job_template.this[each.key].id
  name        = var.surveys[each.value.survey].name
  description = var.surveys[each.value.survey].description
  spec        = var.surveys[each.value.survey].spec
}

output "ids" {
  description = "Job template IDs, keyed as the input was."
  value       = { for key, template in aap_job_template.this : key => template.id }
}
