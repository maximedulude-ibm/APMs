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

Supply any private key through an approved secret mechanism. This workspace
does not read this file or create the example credential; it creates the
default EDA SCM credential directly.
