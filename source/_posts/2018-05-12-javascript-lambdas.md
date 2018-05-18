---
layout: post
title: "Reporting Success in JavaScript Lambdas when Using AppInsights"
tags:
  - JavaScript
  - AWS
  - Lambda
  - AppInsights
categories:
  - Development
authorId: simon_timms
date: 2018-05-15 13:10:00
excerpt: AWS Lambda provides a solid platform for doing serverless coding but when used in conjunction with Application Insights there are some tricks to get the function to return properly.
---

In the last week I've run into two separate AWS Lambdas related to reporting success. See when you have a lambda which is trigged by a cloud watch event (a scheduled lambda) then the runtime will attempt to execute it 3 times in the event of an error. In order to detect if a function has succeeded the runtime needs you to fire the callback with `null` as the first parameter. This can be a little tricky to get right in an asynchronous world. 

The signature of a JavaScript lambda is 

```
lambda(event: any, context: Context, callback: Function)
```

That callback is actually critical to reporting success back to lambda. The reason is that lambda keeps the nodejs runtime active to speed up subsequent calls to the lambda. You certainly don't want to call `process.exit()`, which is something I've done incorrectly a few times now. If you don't report success the function will run until they have used up their time allocation, which is 6 seconds by default, and are killed by the runtime. 

Now with Application Insights you need to call `flush()` before you terminate the function. This ensure that all the logs gathered actually make it up to the Application Insights endpoint. The thing with the flush is that it is actually an asynchronous call. This means you have to be a little careful about when you call the callback. 

The best method I've found is to do

```
tc.flush({
    callback: () => {
        context.succeed('Messages sent');
        callback(null, {});
    }
});
```

or, in a catch block which wraps the lambada body 

```
tc.flush({
    callback: () => {
        context.fail(e);
        callback(e);
    }
});
```

Unfortunately this best practice isn't quite enough for the nodejs Application Insights client. It maintains some active tasks in the event loop which means that the lambda runtime believes that the lambda is still running and doesn't terminate. You can get over this by setting

```
context.callbackWaitsForEmptyEventLoop = false;
```

as the first thing you function does. With all of this in place I've found the writing lambdas in typescript is somewhat palatable.  

# Bonus

*Why the heck are you using Application Insights on AWS? They have Cloud Watch, you know*

Oh because Application Insights is madly, wildly better than anything on AWS. It provides searching, notification, graphing and aggregating at a level that is on par or better than anything I've seen on the market from the likes of Sumo Logic, Log Entries or Tableau. 