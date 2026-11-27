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

This onboarding workspace does not read survey JSON or attach it to a job
template. A future consumer workspace must do both.
