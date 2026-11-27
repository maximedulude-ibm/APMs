# APMs
repo where the apm scaffoldings are created

## Giolab AAP day two workflow

Each `apm<digits>/` folder is a Terraform root for **its own** HCP workspace
and state. All of these workspaces connect to this `APMs` repository on
`main`, but each workspace's Terraform Working Directory is its APM folder.
For example, use `apm9999991` for the existing demo APM and `apm9999992`
for a later APM. Use an amd64 Giolab agent pool. Each folder's Terraform root
calls the AAP module in `maximedulude-ibm/hcp-aap-testmax`.

Configure the AAP endpoint, APM org-admin username and sensitive password,
and the four outputs from **that APM's** bootstrap workspace, as described
in its folder README. Then a commit to a `.yaml` declaration in that folder
triggers its HCP plan. For example,
`apm9999991/credentials/machine-lab.yaml` is already present and should plan
an AAP Machine credential on the first run. Apply the plan after review when
auto-apply is disabled. Keep secret values out of this repository.
# APMs
# APMs
# APMs
