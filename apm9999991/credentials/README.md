# Credentials

Declare credential metadata here. Do not commit secret values.

For example, `machine-lab.yaml` could describe a Controller credential:

```yaml
machine-lab:
  name: "APM9999991_machine-lab"
  credential_type: Machine
  inputs:
    username: ansible
```

The example contains no password or private key. Commit `machine-lab.yaml`
to `APMs/main`; the APM folder's HCP workspace plans and creates this
credential. The platform SCM credential stays in the bootstrap workspace.
