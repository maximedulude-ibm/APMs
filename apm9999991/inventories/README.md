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

Use a real reachable host when you connect a consumer workspace. This
onboarding workspace does not read this file; it creates
`APM9999991_inventory` directly.
