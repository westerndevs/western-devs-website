---
layout: post
title: Application Insights Alerts
authorId: simon_timms
date: 2018-07-01
originalurl: 'https://blog.simontimms.com/2018/07/01/app_insights_alerts/'
---

Application Insights is another entry in the vast array of log aggregators that have been springing up in the last few years. I think log aggregators are very important for any deployed production system. They give you insight into what is happening on the site and should be your first stop whenever something has gone wrong. Being able to search logs and correlate multiple log streams give you just that much more power. One feature I don't see people using as much as they should is basing alerting off of log information. Let's mash on that.

<!-- more -->

Let's define my problem first: I have a number of services which kick off every hour and do some processing. If the services don't run for an hour it isn't a huge deal but a couple of hours of not running and data starts to look stale and that's no good. So I actually want to have an alert when messages don't show up in my logs. 

The first step is to get all your applications reporting correctly to app insights. If you're running in an environment with multiple applications reporting (even if it is just front end and back end) then checkout how to set the [cloud role name](https://blog.simontimms.com/2018/07/01/app_insights_appname/).

Next we set up a monitoring job to use that query. Click into monitor

![Selecting cloud_RoleName](https://blog.simontimms.com/images/app_insights_alerts/monitor.png)

Then you can create a new rule. This process starts by setting up some conditions under which the rule will fire. First select your application insights instance from the target selector. Then under criteria add a `custom log search` and put a query into the `Search Query` field. My query is `customEvents | where cloud_RoleName == "cloud role name"` which selects everything that had the `cloud role name` cloud_RoleName. I want to make sure this shows up in logs so I set a threshold of less than 1 meaning that if 0 messages are recorded the alert will fire. 

![Selecting conditions](https://blog.simontimms.com/images/app_insights_alerts/conditions.png)

Finally, select what should happen when the alert condition is met; this is called an action group. For me it is simply an e-mail notification but you can do a wide variety of things including firing a custom function or logic app to fix the problem.

![Selecting actions](https://blog.simontimms.com/images/app_insights_alerts/full.png)

And just like that we've turned passive monitoring into active monitoring with alerts sent to interested parties. A word of caution: don't abuse this new found power. People rapidly become desensitized to alerts which fire too frequently so make sure you're not clobbering people with too much information.