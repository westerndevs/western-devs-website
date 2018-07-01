---
layout: post
title: Application Insights Cloud Role Name
authorId: simon_timms
date: 2018-07-01
originalurl: 'https://blog.simontimms.com/2018/07/01/app_insights_appname/'
---

Logging is super important in any microservices environment or really any production environment. Being able to trace where your log messages are coming from is very helpful. Fortunately Application Insights have a field defined for just that.

<!--more-->

The field we should be looking at is called `cloud_RoleName` in the Analytics page. You'll need to set this in your logging client. Depending on the language you're using the way to do this differs. 

Let's say that we're going to call our application EMailSender the this is how to set it. (All of these assume you're Applications Insights Client is called `appInsightsClient`)

## C {% raw %}# {% endraw %}

```csharp
appInsightsClient.Context.Cloud.RoleName = "EMailSender"
```

## F {% raw %}# {% endraw %}

```fsharp
appInsightsClient.Context.Cloud.RoleName <- "EMailSender"
```

## VB.NET

```csharp
appInsightsClient.Context.Cloud.RoleName = "EMailSender"
```

## Server-side JavaScript

```javascript
appInsightsClient.context.tags[appInsightsClient.context.keys.cloudRole] = 'EMailSender';
```

## Client-side JavaScript

This one is a little different 

```javascript
appInsightsClient.queue.push(() => {
    appInsightsClient.context.addTelemetryInitializer((envelope: Microsoft.ApplicationInsights.IEnvelope) => {
                    envelope.tags['ai.cloud.role'] = "EMailSender";
                });
});
```

## Python

```python
appInsightsClient.context.device.role_name = 'EMailSender'
```

In the portal we can now add a new column to our search  results called cloud_RoleName which should be populated with `EMailSender`. We can use this field in any query as needed.

![Selecting cloud_RoleName](https://blog.simontimms.com/images/app_insights_appname/select.png)

I like to drag that column to the left-hand side so I can see it right away.