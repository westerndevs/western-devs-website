---
title:  Logging in Functions
authorId: simon_timms
date: 2021-05-08
originalUrl: https://blog.simontimms.com/2021/05/08/function-appinsights.md
mode: public
---



Looks like by default functions log at the `info` level. To change the level you can use set the application setting `AzureFunctionsJobHost__logging__LogLevel__Default` to some other value like `Error` or `Info`. 

If you want to disable adaptive sampling then that can be done in the host.json

```json
{
  "version": "2.0",
  "extensions": {
    "queues": {
      "maxPollingInterval": "00:00:05"
    }
  },
  "logging": {
    "logLevel": {
      "default": "Information"
    },
    "applicationInsights": {
      "samplingSettings": {
        "isEnabled": false
      }
    }
  },
  "functionTimeout": "00:10:00"
}
```
In this example adaptive sampling is turned off so you get every log message.

A thing to note is that if you crank down logging to Error you won't see the invocations at all in the portal but they're still running.