output "ids" {
  description = "Workflow job template IDs, keyed by workflow key. Workflows with no nodes or steps are omitted."
  value       = { for key, workflow in aap_workflow_job_template.this : key => workflow.id }
}

output "node_ids" {
  description = "Workflow node IDs, keyed by workflow key and then node key."
  value = {
    for workflow_key, workflow in local.populated_workflows : workflow_key => {
      for node_key in keys(local.nodes_by_workflow[workflow_key]) :
      node_key => aap_workflow_job_template_job_node.this[jsonencode([workflow_key, node_key])].id
    }
  }
}
