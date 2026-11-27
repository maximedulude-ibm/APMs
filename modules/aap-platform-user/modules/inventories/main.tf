locals {
  hosts = merge([for key, inventory in var.inventories : {
    for host_name, host in inventory.hosts :
    "${key}.${host_name}" => merge(host, { inventory_key = key, name = host_name })
  }]...)

  groups = merge([for key, inventory in var.inventories : {
    for group_name, group in inventory.groups :
    "${key}.${group_name}" => merge(group, { inventory_key = key, name = group_name })
  }]...)

  group_memberships = {
    for membership in flatten([
      for key, inventory in var.inventories : [
        for group_name, group in inventory.groups : [
          for host_name in group.hosts : {
            key           = "${key}.${group_name}.${host_name}"
            inventory_key = key
            group_key     = "${key}.${group_name}"
            host_key      = "${key}.${host_name}"
          }
        ]
      ]
    ]) : membership.key => membership
  }

  inventory_variables = { for key, inv in var.inventories :
    key => inv.variables == null ? null : (
      can(keys(yamldecode(inv.variables))) ? inv.variables : join("\n", [for pair in compact(split(" ", trimspace(inv.variables))) : replace(pair, "=", ": ")])
    )
  }
  host_variables = { for key, host in local.hosts :
    key => host.variables == null ? null : (
      can(keys(yamldecode(host.variables))) ? host.variables : join("\n", [for pair in compact(split(" ", trimspace(host.variables))) : replace(pair, "=", ": ")])
    )
  }
  group_variables = { for key, group in local.groups :
    key => group.variables == null ? null : (
      can(keys(yamldecode(group.variables))) ? group.variables : join("\n", [for pair in compact(split(" ", trimspace(group.variables))) : replace(pair, "=", ": ")])
    )
  }
}

resource "aap_inventory" "this" {
  for_each = var.inventories

  name         = each.value.name
  organization = var.organization_id
  description  = each.value.description
  variables    = local.inventory_variables[each.key]
}

resource "aap_host" "this" {
  for_each = local.hosts

  name        = each.value.name
  inventory   = tonumber(aap_inventory.this[each.value.inventory_key].id)
  description = each.value.description
  enabled     = each.value.enabled
  variables   = local.host_variables[each.key]
}

resource "aap_group" "this" {
  for_each = local.groups

  name        = each.value.name
  inventory   = tonumber(aap_inventory.this[each.value.inventory_key].id)
  description = each.value.description
  variables   = local.group_variables[each.key]
}

resource "aap_group_host" "this" {
  for_each = local.group_memberships

  group_id = aap_group.this[each.value.group_key].id
  host_id  = aap_host.this[each.value.host_key].id

  lifecycle {
    precondition {
      condition     = contains(keys(local.hosts), each.value.host_key)
      error_message = "inventories/${each.value.inventory_key}: group \"${each.value.group_key}\" lists host \"${each.value.host_key}\" which is not defined under that inventory's hosts. Define it there, or remove it from the group."
    }
  }
}

output "ids" {
  description = "Inventory IDs, keyed as the input was."
  value       = { for key, inventory in aap_inventory.this : key => inventory.id }
}
