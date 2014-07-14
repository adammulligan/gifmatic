# Gifmatic

Simple express server that handles `/gif` commands from Slack, returning
a matching image from the Giphy API.

## Usage

Drop a Slack Incoming Webhook URL in to the app, and then:

```
# starts a server on port 4567
coffee index.coffee
```

Setup a Slack Slash Command to POST to the above port, e.g. `/gif <gif
query>`.
