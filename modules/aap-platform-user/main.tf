locals {
  organization_name = var.organization_name

  credential_types_to_look_up = {
    for key, credential in var.credentials :
    key => credential.credential_type
    if credential.credential_type_id == null && contains(keys(var.allowed_credential_types), credential.credential_type)
  }

  eda_credential_types_to_look_up = {
    for key, credential in var.eda_credentials :
    key => credential.credential_type
    if contains(var.allowed_eda_credential_types, credential.credential_type)
  }

  execution_environments_to_look_up = {
    for key, template in var.job_templates :
    key => template.execution_environment
    if template.execution_environment != null && var.allowed_execution_environments != []
  }
}

data "aap_organization" "this" {
  name = local.organization_name
}

data "aap_credential_type" "declared" {
  for_each = local.credential_types_to_look_up

  name = each.value
  kind = coalesce(var.credentials[each.key].credential_type_kind, var.allowed_credential_types[each.value])
}

data "aap_eda_credential_type" "declared" {
  for_each = local.eda_credential_types_to_look_up

  name = each.value
}

data "aap_execution_environment" "declared" {
  for_each = local.execution_environments_to_look_up

  name = each.value
}

module "projects" {
  source = "./modules/projects"

  organization_id = data.aap_organization.this.id
  credential_ids  = module.credentials.ids
  projects        = var.projects

  platform_scm_credential_id = var.platform_scm_credential_id
}

module "eda_projects" {
  source = "./modules/eda_projects"

  organization_id                = tonumber(data.aap_organization.this.eda_id)
  projects                       = var.eda_projects
  platform_eda_scm_credential_id = var.platform_eda_scm_credential_id
  credential_ids                 = module.eda_credentials.ids
}

module "inventories" {
  source = "./modules/inventories"

  organization_id = data.aap_organization.this.id
  inventories     = var.inventories
}

module "credentials" {
  source = "./modules/credentials"

  organization_id         = data.aap_organization.this.id
  allowed_types           = var.allowed_credential_types
  type_ids                = { for key, type in data.aap_credential_type.declared : key => tonumber(type.id) }
  credentials             = var.credentials
  credential_version_seed = var.credential_version_seed
}

module "eda_credentials" {
  source = "./modules/eda_credentials"

  organization_id = tonumber(data.aap_organization.this.eda_id)
  credentials     = var.eda_credentials
  allowed_types   = var.allowed_eda_credential_types
  type_ids        = { for key, type in data.aap_eda_credential_type.declared : key => tonumber(type.id) }
  permitted_input_ids = {
    for key, type in data.aap_eda_credential_type.declared :
    key => toset([for field in jsondecode(type.inputs).fields : tostring(field.id) if !try(field.secret, false)])
  }
}

module "job_templates" {
  source = "./modules/job_templates"

  organization_id = data.aap_organization.this.id
  job_templates   = var.job_templates
  surveys         = var.job_template_surveys

  project_ids    = merge(module.projects.ids, var.platform_project_id == null ? {} : { platform = tostring(var.platform_project_id) })
  inventory_ids  = merge(module.inventories.ids, var.platform_inventory_id == null ? {} : { platform = tostring(var.platform_inventory_id) })
  credential_ids = module.credentials.ids

  execution_environment_ids = {
    for key, ee in data.aap_execution_environment.declared : key => tonumber(ee.id)
  }
  allowed_execution_environments = var.allowed_execution_environments

}

module "workflow_job_templates" {
  source = "./modules/workflow_job_templates"

  organization_id        = data.aap_organization.this.id
  workflow_job_templates = var.workflow_job_templates
  job_template_ids       = module.job_templates.ids
}

module "schedules" {
  source = "./modules/schedules"

  schedules        = var.schedules
  job_template_ids = module.job_templates.ids
  inventory_ids    = merge(module.inventories.ids, var.platform_inventory_id == null ? {} : { platform = tostring(var.platform_inventory_id) })
}

module "notifications" {
  source = "./modules/notifications"

  organization_id  = data.aap_organization.this.id
  notifications    = var.notifications
  job_template_ids = module.job_templates.ids

}

output "organization" {
  description = "The organization this module manages, as resolved from AAP."
  value = {
    name       = data.aap_organization.this.name
    id         = data.aap_organization.this.id
    gateway_id = data.aap_organization.this.gateway_id
  }
}

output "project_ids" {
  description = "Project IDs, keyed by the key used in projects/."
  value       = module.projects.ids
}

output "eda_project_ids" {
  description = "EDA project IDs, keyed by the key used in eda-projects/."
  value       = module.eda_projects.ids
}

output "inventory_ids" {
  description = "Inventory IDs, keyed by the key used in inventories/."
  value       = module.inventories.ids
}

output "credential_ids" {
  description = "Credential IDs, keyed by the key used in credentials/."
  value       = module.credentials.ids
}

output "eda_credential_ids" {
  description = "EDA credential IDs, keyed by the key used in eda-credentials/."
  value       = module.eda_credentials.ids
}

output "job_template_ids" {
  description = "Job template IDs, keyed by the key used in job-templates/."
  value       = module.job_templates.ids
}

output "workflow_job_template_ids" {
  description = "Workflow job template IDs, keyed by workflow key. Empty workflows are omitted."
  value       = module.workflow_job_templates.ids
}

output "workflow_job_template_node_ids" {
  description = "Workflow node IDs, keyed by workflow key and then node key."
  value       = module.workflow_job_templates.node_ids
}

output "notification_ids" {
  description = "Notification template IDs, keyed by the key used in notifications/."
  value       = module.notifications.ids
}
