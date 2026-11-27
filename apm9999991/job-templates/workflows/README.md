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

This onboarding workspace does not read workflow YAML. A future consumer
workspace must create the referenced `hello` job template before this
example can be used.
