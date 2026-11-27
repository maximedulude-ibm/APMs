# EDA projects

The onboarding workspace creates the default `APM9999991_SHARED` EDA project directly.
`platform.yaml` records its intended settings for review; it is not applied
from this folder.

For example, `additional.yaml` could describe another EDA project:

```yaml
additional:
  name: "APM9999991_additional-eda"
  scm_type: git
  scm_url: "ssh://git@ssh.github.com:443/maximedulude-ibm/APMs.git"
  scm_branch: main
  scm_credential: platform
```

EDA looks for `rulebooks/` at the shared repository root. The APM folder's HCP workspace reads additional EDA project declarations.
The `platform` credential key maps to the bootstrap-managed
`APM9999991_platform-eda-scm` credential using its ID from the first
workspace.
