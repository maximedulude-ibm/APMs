# Surveys

Add survey JSON files here.

For example, `hello.json` could ask for a message:

```json
{
  "name": "Hello survey",
  "description": "Choose a message for the demo job",
  "spec": [
    {
      "question_name": "Message",
      "variable": "message",
      "type": "text",
      "required": true
    }
  ]
}
```

The APM folder's HCP workspace reads this JSON. Set `survey: hello` in a
job template declaration to attach it.
