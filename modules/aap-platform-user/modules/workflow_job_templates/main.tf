locals {
  populated_workflows = {
    for key, workflow in var.workflow_job_templates : key => workflow
    if length(workflow.nodes) > 0 || length(workflow.steps) > 0
  }

  nodes_by_workflow = {
    for workflow_key, workflow in local.populated_workflows : workflow_key => (
      length(workflow.steps) > 0 ? merge([for step in workflow.steps : { (step.key) = step.job_template }]...) : workflow.nodes
    )
  }

  nodes = merge([for workflow_key, nodes in local.nodes_by_workflow : {
    for node_key, job_template_key in nodes :
    jsonencode([workflow_key, node_key]) => {
      workflow_key     = workflow_key
      node_key         = node_key
      job_template_key = job_template_key
    }
  }]...)

  success_links = merge([for workflow_key, workflow in local.populated_workflows : {
    for index, step in workflow.steps :
    jsonencode([workflow_key, step.key]) => {
      workflow_key = workflow_key
      source_key   = step.key
      target_key   = try(workflow.steps[index + 1].key, null)
    }
    if index + 1 < length(workflow.steps)
  }]...)
}

resource "aap_workflow_job_template" "this" {
  for_each = local.populated_workflows

  name         = each.value.name
  description  = each.value.description
  organization = tonumber(var.organization_id)
}

resource "aap_workflow_job_template_job_node" "this" {
  for_each = local.nodes

  identifier               = each.value.node_key
  workflow_job_template_id = tonumber(aap_workflow_job_template.this[each.value.workflow_key].id)
  unified_job_template     = tonumber(lookup(var.job_template_ids, each.value.job_template_key, null))

  lifecycle {
    precondition {
      condition     = contains(keys(var.job_template_ids), each.value.job_template_key)
      error_message = "workflow_job_templates/${each.value.workflow_key}: node \"${each.value.node_key}\" names job template \"${each.value.job_template_key}\", which is not declared in job_templates."
    }
  }
}

resource "aap_workflow_job_template_node_success" "this" {
  for_each = local.success_links

  id = aap_workflow_job_template_job_node.this[jsonencode([
    each.value.workflow_key, each.value.source_key
  ])].id
  success_ids = [tonumber(aap_workflow_job_template_job_node.this[jsonencode([
    each.value.workflow_key, each.value.target_key
  ])].id)]
}
