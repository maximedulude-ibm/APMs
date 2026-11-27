provider "aap" {
  endpoint             = var.aap_endpoint
  username             = var.aap_username
  password             = var.aap_password
  insecure_skip_verify = var.aap_insecure_skip_verify
}

locals {
  project_files        = fileset(path.module, "projects/**/*.yaml")
  eda_project_files    = setsubtract(fileset(path.module, "eda-projects/**/*.yaml"), ["eda-projects/platform.yaml"])
  inventory_files      = fileset(path.module, "inventories/**/*.yaml")
  credential_files     = fileset(path.module, "credentials/**/*.yaml")
  eda_credential_files = fileset(path.module, "eda-credentials/**/*.yaml")
  workflow_files       = fileset(path.module, "job-templates/workflows/**/*.yaml")
  survey_files         = fileset(path.module, "job-templates/surveys/**/*.json")
  schedule_files       = fileset(path.module, "job-templates/schedules/**/*.yaml")
  notification_files   = fileset(path.module, "job-templates/notifications/**/*.yaml")
  job_template_files = setsubtract(
    fileset(path.module, "job-templates/**/*.yaml"),
    setunion(local.workflow_files, local.schedule_files, local.notification_files),
  )

  yaml_files = setunion(
    local.project_files, local.eda_project_files, local.inventory_files,
    local.credential_files, local.eda_credential_files, local.job_template_files,
    local.workflow_files, local.schedule_files, local.notification_files,
  )
  misnamed_files = [for f in local.yaml_files : f
    if join(",", try(keys(yamldecode(file("${path.module}/${f}"))), [])) != trimsuffix(basename(f), ".yaml")
  ]
  reserved_files = setintersection(
    setunion(local.project_files, local.inventory_files),
    ["projects/platform.yaml", "inventories/platform.yaml"],
  )
  unsupported_vault_files = [for f in local.job_template_files : f
    if anytrue([for entry in try(values(yamldecode(file("${path.module}/${f}"))), []) :
      try(contains(keys(entry), "vault_identity"), false)
    ])
  ]
}

module "aap_platform_user" {
  source = "../modules/aap-platform-user"

  organization_name = "APM9999991_SHARED"

  platform_scm_credential_id     = var.platform_scm_credential_id
  platform_eda_scm_credential_id = var.platform_eda_scm_credential_id
  platform_project_id            = var.platform_project_id
  platform_inventory_id          = var.platform_inventory_id
  credential_version_seed        = var.credential_version_seed

  projects               = merge([for f in local.project_files : yamldecode(file("${path.module}/${f}"))]...)
  eda_projects           = merge([for f in local.eda_project_files : yamldecode(file("${path.module}/${f}"))]...)
  inventories            = merge([for f in local.inventory_files : yamldecode(file("${path.module}/${f}"))]...)
  credentials            = merge([for f in local.credential_files : yamldecode(file("${path.module}/${f}"))]...)
  eda_credentials        = merge([for f in local.eda_credential_files : yamldecode(file("${path.module}/${f}"))]...)
  job_templates          = merge([for f in local.job_template_files : yamldecode(file("${path.module}/${f}"))]...)
  workflow_job_templates = merge([for f in local.workflow_files : yamldecode(file("${path.module}/${f}"))]...)
  job_template_surveys   = { for f in local.survey_files : trimsuffix(basename(f), ".json") => jsondecode(file("${path.module}/${f}")) }
  schedules              = merge([for f in local.schedule_files : yamldecode(file("${path.module}/${f}"))]...)
  notifications          = merge([for f in local.notification_files : yamldecode(file("${path.module}/${f}"))]...)
}

output "entry_keys_match_file_names" {
  value = length(local.misnamed_files) == 0 && length(local.reserved_files) == 0 && length(local.unsupported_vault_files) == 0

  precondition {
    condition     = length(local.misnamed_files) == 0
    error_message = "Each YAML file must contain one entry whose key matches its filename: ${join(", ", local.misnamed_files)}."
  }

  precondition {
    condition     = length(local.reserved_files) == 0
    error_message = "The platform project and inventory keys are reserved for bootstrap resources: ${join(", ", local.reserved_files)}."
  }

  precondition {
    condition     = length(local.unsupported_vault_files) == 0
    error_message = "Vault job identities are not supported in the Giolab demo: ${join(", ", local.unsupported_vault_files)}."
  }
}

output "credential_ids" {
  value = module.aap_platform_user.credential_ids
}
