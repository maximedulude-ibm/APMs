# APMs
repo where the apm scaffoldings are created
# APMs
# APMs
# APMs

## Giolab AAP day two workspaces

Each `apm<digits>/` folder is a Terraform root for its own HCP workspace and
state. All workspaces use this `APMs` repository on `main`; set each working
directory to its matching APM folder. For example, `apm9999991` uses a
workspace such as `aap-platform-user-apm9999991` with working directory
`apm9999991`. A later `apm9999992` uses its own workspace and directory.

The roots call the shared AAP module in `modules/aap-platform-user` by a
relative path. HCP checks it out together with this repository, so module
initialization needs no separate GitHub authentication. For VCS run triggers,
include both the APM folder and `modules/**` so a module change queues runs
for the workspaces that use it. Use a Linux amd64 Giolab agent pool.

Set the AAP credentials and bootstrap resource IDs described in each APM
folder's README. A commit to that folder's YAML declarations then queues its
HCP plan. The existing `apm9999991/credentials/machine-lab.yaml` is the first
example. Review and apply the plan if auto-apply is disabled. Keep secrets
out of Git.
