# Workflows

Add workflow job template declarations here.

For example, `demo.yaml` could describe two job nodes:

```yaml
demo:
  name: "APM9999991_demo-workflow"
  steps:
    - key: first
      job_template: hello
    - key: second
      job_template: hello
```

The APM folder's HCP workspace reads workflow YAML and creates the workflow.
The referenced `hello` job template must also be declared under
`job-templates/`.
