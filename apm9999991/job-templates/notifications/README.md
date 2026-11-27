# Notifications

Add notification declarations here.

For example, `hello-webhook.yaml` could describe a success notification:

```yaml
hello-webhook:
  name: "APM9999991_hello-webhook"
  notification_type: webhook
  url: "https://example.invalid/aap-events"
  configuration:
    http_method: POST
  events:
    hello:
      success: true
```

Replace the sample URL and connect a consumer workspace before using this
declaration. The onboarding workspace does not read notification YAML.
