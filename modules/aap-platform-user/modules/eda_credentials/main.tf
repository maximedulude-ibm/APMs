resource "aap_eda_credential" "this" {
  for_each = var.credentials

  name               = each.value.name
  description        = each.value.description
  organization_id    = var.organization_id
  credential_type_id = try(var.type_ids[each.key], 0)
  inputs             = length(each.value.inputs) > 0 ? jsonencode(each.value.inputs) : null

  lifecycle {
    precondition {
      condition     = contains(var.allowed_types, each.value.credential_type)
      error_message = "eda-credentials/${each.key}: credential_type \"${each.value.credential_type}\" is not in allowed_eda_credential_types."
    }

    precondition {
      condition     = contains(keys(var.type_ids), each.key)
      error_message = "eda-credentials/${each.key}: credential_type \"${each.value.credential_type}\" must resolve to an installed EDA credential type by name."
    }

    precondition {
      condition     = length(setsubtract(toset(keys(each.value.inputs)), try(var.permitted_input_ids[each.key], toset([])))) == 0
      error_message = "eda-credentials/${each.key}: inputs contains an unknown or secret field. EDA inputs are stored in Terraform state; put only fields marked non-secret by the live credential type in YAML."
    }

    precondition {
      condition     = length(each.value.inputs) == 0 || contains(keys(var.permitted_input_ids), each.key)
      error_message = "eda-credentials/${each.key}: non-empty inputs require the live credential type's input schema."
    }
  }
}

output "ids" {
  description = "EDA credential IDs, keyed by declaration key."
  value       = { for key, credential in aap_eda_credential.this : key => credential.id }
}
