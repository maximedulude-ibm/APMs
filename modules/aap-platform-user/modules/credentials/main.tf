resource "aap_credential" "this" {
  for_each = var.credentials

  name        = each.value.name
  description = each.value.description

  organization = var.organization_id

  credential_type = each.value.credential_type_id != null ? each.value.credential_type_id : try(var.type_ids[each.key], 0)

  inputs_wo = length(each.value.inputs) > 0 ? jsonencode(each.value.inputs) : null
  # The provider cannot compare write-only inputs with state. Hash the
  # non-secret declaration so editing it resends the new value on the next run.
  inputs_wo_version = var.credential_version_seed + parseint(substr(sha256(jsonencode(each.value.inputs)), 0, 7), 16)

  lifecycle {
    precondition {
      condition     = contains(keys(var.allowed_types), each.value.credential_type)
      error_message = "credentials/${each.key}: credential_type \"${each.value.credential_type}\" is not one the platform sanctions. Permitted types: ${join(", ", keys(var.allowed_types))}. If a new type is genuinely needed, that is a platform request, not a repository change."
    }
  }
}

output "ids" {
  description = "Credential IDs, keyed as the input was."
  value       = { for key, credential in aap_credential.this : key => credential.id }
}
