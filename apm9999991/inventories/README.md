# Inventories

Place inventory declarations here after the AAP tier workspace is connected.

For example, `lab.yaml` could describe a host and group:

```yaml
lab:
  name: "APM9999991_lab"
  hosts:
    demo-host:
      variables: "ansible_host: 192.0.2.10"
  groups:
    demo:
      hosts:
        - demo-host
```

Use a real reachable host for a live inventory. The APM folder's HCP
workspace reads this YAML and creates the inventory. The bootstrap workspace
owns `APM9999991_inventory`, available to job templates as `platform`.
