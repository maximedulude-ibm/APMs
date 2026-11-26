# APM9999991_SHARED AAP configuration

This folder is created inside the shared APMs GitHub repository by the
standalone HCP Terraform AAP workflow. Its HCP workspace owns the AAP
organization, teams, SCM credentials, and default EDA project.

Add playbooks under `job-templates/playbooks/` and declarations under the
other folders. Those files are reviewable Git scaffolding; the bootstrap
workflow does not automatically apply new day two declarations. Connect a
separate AAP tier workspace before treating them as managed objects.

The folder is retained on decommission for audit.
