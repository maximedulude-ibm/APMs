# Giolab AAP day two module

This is the AAP platform user module adapted from the existing onboarding
pipeline for the Giolab HCP demo. It manages Controller and EDA projects,
inventories, Controller and EDA credentials, job templates, workflows,
surveys, schedules, and notifications in one existing AAP organization.

The Giolab copy uses only the `tfbrew/aap` provider. Vault job identities and
Vault credential types are removed. The APM folder's Terraform root rejects
`vault_identity` in job template declarations and never commits secret values.

The bootstrap workspace continues to own the organization, default
Controller and EDA projects, default inventory, and platform SCM credentials.
Pass their IDs to this module when a day two resource refers to them. They
are never recreated in this module's state.

Each `APMs/<apm>/main.tf` reads its declaration folders and calls this shared
module through `../modules/aap-platform-user` in the same VCS checkout. Test
changes with `terraform init -backend=false` and `terraform validate` before
merging.
