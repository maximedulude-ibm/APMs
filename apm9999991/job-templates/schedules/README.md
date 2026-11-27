# Schedules

Add schedule declarations here.

For example, `hello-daily.yaml` could describe a daily launch:

```yaml
hello-daily:
  name: "APM9999991_hello-daily"
  unified_job_template: hello
  rrule: "DTSTART:20270101T020000Z RRULE:FREQ=DAILY;INTERVAL=1"
  enabled: false
```

The `hello` key refers to the example in `../README.md`. This onboarding
workspace does not read schedule YAML, so this file will not start a job.
