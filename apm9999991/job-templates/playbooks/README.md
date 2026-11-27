# Playbooks

Add Ansible playbooks here.

For example, create `hello.yml`:

```yaml
---
- name: Hello from this APM
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Show a message
      ansible.builtin.debug:
        msg: "Hello from APM9999991_SHARED"
```

Commit it to the shared repository and sync the Controller project. Its AAP
playbook path is `apm9999991/job-templates/playbooks/hello.yml`. A job
template is still needed to launch it.
