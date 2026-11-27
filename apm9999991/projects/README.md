# Controller projects

The onboarding workspace already creates `APM9999991_platform-controller`
from the shared `APMs` repository. It uses the platform-managed
`APM9999991_platform-scm` credential.

Add declarations for other Controller projects here after an AAP tier
workspace is connected. Files in this folder are not applied by the
onboarding workspace.

For example, `additional.yaml` could describe another project that uses
the shared repository and the existing SCM credential:

```yaml
additional:
  name: "APM9999991_additional-project"
  scm_type: git
  scm_url: "ssh://git@ssh.github.com:443/maximedulude-ibm/APMs.git"
  scm_branch: main
  scm_credential: platform
```

The `platform` credential key illustrates how a future consumer workspace
could refer to the Terraform-managed `APM9999991_platform-scm` credential.
That consumer and key mapping have not been implemented in this demo.
