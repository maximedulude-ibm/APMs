# APM9999991_SHARED AAP configuration

This folder is created inside the shared APMs GitHub repository by the
standalone HCP Terraform AAP workflow. The bootstrap HCP workspace owns the
AAP organization, teams, default inventory, SCM credentials, Controller
project, and default EDA project. It also creates the day two HCP workspace
`APM9999991` in the `PLATFORM` project. That workspace watches the
shared `APMs` repository with working directory `apm9999991` and creates
the resources declared below. Other APM folders use separate workspaces and
states.

This APM's day two workspace calls `../modules/aap-platform-user` from the
same `APMs` checkout. Bootstrap sets its AAP endpoint, generated
`APM9999991_SHARED` organization administrator password, and IDs of the default
project, inventory, and SCM credentials. Auto-apply is disabled so you can
inspect each plan before applying.

The Controller project `APM9999991_platform-controller` and the EDA
project `APM9999991_SHARED` both clone the **whole** `APMs` repository from
`ssh://git@ssh.github.com:443/maximedulude-ibm/APMs.git`. The Controller SCM credential is
`APM9999991_platform-scm`; the EDA SCM credential is
`APM9999991_platform-eda-scm`.

## Example: add a Controller playbook

Create `apm9999991/job-templates/playbooks/hello.yml` in this repository:

```yaml
---
- name: Demo playbook
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Show the APM
      ansible.builtin.debug:
        msg: "Hello from APM9999991_SHARED"
```

After the Controller project syncs, create
`job-templates/hello.yaml` in this APM folder:

```yaml
hello:
  name: "APM9999991_hello"
  project: platform
  inventory: platform
  playbook: "apm9999991/job-templates/playbooks/hello.yml"
```

The next HCP run creates that job template using the existing bootstrap
project and inventory. Its effective AAP fields are:

| Field | Value |
| --- | --- |
| Project | `APM9999991_platform-controller` |
| Inventory | `APM9999991_inventory` |
| Playbook | `apm9999991/job-templates/playbooks/hello.yml` |

The playbook path includes `apm9999991/` because the project clones the
repository root.

## Example: EDA project source

`eda-projects/platform.yaml` records the default EDA project's SCM settings.
The bootstrap workspace creates the AAP EDA project directly. This APM's day
two workspace excludes `platform.yaml` so it does not create a duplicate. EDA searches
for a `rulebooks/` directory at the **repository root**, so the workspace
also creates `rulebooks/apm9999991/README.md` outside this APM folder. Add
this APM's `.yml` or `.yaml` rulebooks there when you are ready to test an
activation.

Add playbooks under `job-templates/playbooks/` and declarations under the
other folders. YAML declarations and survey JSON are read by this folder's
`main.tf` on the next HCP run. Commit to `main` to trigger that run; when
auto-apply is off, review the plan and select **Apply**. Only `.yaml`
declarations and `.json` surveys are read, so playbooks can use `.yml`.
Never put passwords, keys, or tokens in Git.

The folder is retained on decommission for audit.
