# Job templates

Put playbooks and reviewed job template declarations in this directory.

For example, `hello.yaml` could describe a job using the playbook in
`playbooks/hello.yml`:

```yaml
hello:
  name: "APM9999991_hello"
  job_type: run
  project: platform
  inventory: platform
  playbook: "apm9999991/job-templates/playbooks/hello.yml"
```

The playbook path starts with `apm9999991/` because Controller clones the
shared repository root. The `platform` keys refer to the bootstrap-managed
project and inventory IDs supplied to the APM folder's HCP workspace.
Commit this file to plan and create the job template.
