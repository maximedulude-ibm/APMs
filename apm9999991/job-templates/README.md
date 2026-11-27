# Job templates

Put playbooks and reviewed job template declarations in this directory.

For example, `hello.yaml` could describe a job using the playbook in
`playbooks/hello.yml`:

```yaml
hello:
  name: "APM9999991_hello"
  job_type: run
  project: "APM9999991_platform-controller"
  inventory: "APM9999991_inventory"
  playbook: "apm9999991/job-templates/playbooks/hello.yml"
```

The playbook path starts with `apm9999991/` because Controller clones the
shared repository root. This workspace does not read job template YAML;
create the job template manually for the demo.
