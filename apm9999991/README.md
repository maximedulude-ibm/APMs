# APM9999991_SHARED AAP configuration

This folder is created inside the shared APMs GitHub repository by the
standalone HCP Terraform AAP workflow. Its HCP workspace owns the AAP
organization, teams, inventory, SCM credentials, Controller project, and
default EDA project.

The Controller project `APM9999991_platform-controller` and the EDA
project `APM9999991_SHARED` both clone the **whole** `APMs` repository from
`git@github.com:maximedulude-ibm/APMs.git`. The Controller SCM credential is
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

After the Controller project syncs, create a job template in AAP with:

| Field | Value |
| --- | --- |
| Project | `APM9999991_platform-controller` |
| Inventory | `APM9999991_inventory` |
| Playbook | `apm9999991/job-templates/playbooks/hello.yml` |

The playbook path includes `apm9999991/` because the project clones the
repository root. The job template is a manual demo step; this HCP workspace
does not create job templates from Git files.

## Example: EDA project source

`eda-projects/platform.yaml` records the default EDA project's SCM settings.
The HCP workspace creates the AAP EDA project directly. That YAML file is
reviewable scaffolding and is not applied by this workspace. EDA searches
for a `rulebooks/` directory at the **repository root**, so the workspace
also creates `rulebooks/apm9999991/README.md` outside this APM folder. Add
this APM's `.yml` or `.yaml` rulebooks there when you are ready to test an
activation.

Add playbooks under `job-templates/playbooks/` and declarations under the
other folders. Those files are reviewable Git scaffolding; the bootstrap
workflow does not automatically apply new day two declarations. Connect a
separate AAP tier workspace before treating them as managed objects.

The folder is retained on decommission for audit.
