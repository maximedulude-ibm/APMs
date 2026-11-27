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

The example contains no password or private key. This workspace does not
read this file or create the example credential; its current SCM credential
is managed directly by Terraform.
