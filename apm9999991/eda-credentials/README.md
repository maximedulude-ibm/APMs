# EDA credentials

Declare non-secret EDA credential metadata here.

For example, `vendor-scm.yaml` could describe another Source Control
credential:

```yaml
vendor-scm:
  name: "APM9999991_vendor-scm"
  credential_type: Source Control
  inputs:
    username: git
```

Do not commit a private key. The APM folder's HCP workspace reads this YAML
and creates the example credential; the bootstrap workspace owns the default
EDA SCM credential.
