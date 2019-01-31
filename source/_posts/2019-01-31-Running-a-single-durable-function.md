layout: post
title: Running a single instance of a durable function
authorId: simon_timms
date: 2019-01-31 9:00
originalurl: https://blog.simontimms.com/2019/01/31/2019-01-31-Running-a-single-durable-function/
---

I have a durable functions project which orchestrates several thousand function calls the purpose of which is to scrape and load a bunch of data. It is scheduled to run once a day but one of my concerns was that I didn't want to accidentally run to functions at the same time. They would duplicate a bunch of the data loading and, at least until the function ran again, chaos would reign. I'm not a huge fan of chaos reigning so I set out to find a way around this. 

<!--More-->

If you've ever launched a durable function from the default HTTP triggered template you might have noticed that the JSON returned contains a number of interesting looking urls.

```javascript

{
	"id": "ad6b8019-b356-4099-b70c-a2b503168db3",
	"statusQueryGetUri": "http://localhost:7071/runtime/webhooks/durabletask/instances/ad6b8019-b356-4099-b70c-a2b503168db3?taskHub=DataIngest&connection=Storage&code=ra8WlNh5Vadbj0tqQddXXoZKpkamqMMt2zzfhnmais0SD1K1VzppuA==",
	"sendEventPostUri": "http://localhost:7071/runtime/webhooks/durabletask/instances/ad6b8019-b356-4099-b70c-a2b503168db3/raiseEvent/{eventName}?taskHub=DataIngest&connection=Storage&code=ra8WlNh5Vadbj0tqQddXXoZKpkamqMMt2zzfhnmais0SD1K1VzppuA==",
	"terminatePostUri": "http://localhost:7071/runtime/webhooks/durabletask/instances/ad6b8019-b356-4099-b70c-a2b503168db3/terminate?reason={text}&taskHub=DataIngest&connection=Storage&code=ra8WlNh5Vadbj0tqQddXXoZKpkamqMMt2zzfhnmais0SD1K1VzppuA==",
	"rewindPostUri": "http://localhost:7071/runtime/webhooks/durabletask/instances/ad6b8019-b356-4099-b70c-a2b503168db3/rewind?reason={text}&taskHub=DataIngest&connection=Storage&code=ra8WlNh5Vadbj0tqQddXXoZKpkamqMMt2zzfhnmais0SD1K1VzppuA=="
}
```

The one we're interested in there is the `statusQueryGetUri`. Poking at that gets you something like 

```javascript
{
	"instanceId": "ad6b8019-b356-4099-b70c-a2b503168db3",
	"runtimeStatus": "Completed",
	"input": "ad6b8019-b356-4099-b70c-a2b503168db3",
	"customStatus": null,
	"output": null,
	"createdTime": "2019-01-30T23:09:20Z",
	"lastUpdatedTime": "2019-01-30T23:10:25Z"
}
```

Notice that there is a `runtimeStatus` field there which reports the status of the orchestration. If we could look at the running orchestrations then perhaps we could see if there is already one running. Playing with the status URL I found that you could see all the running instances by simply looking at `http://localhost:7071/runtime/webhooks/durabletask/instances`.

Even better than that the DurableOrchestrationClient used to start an orchestration has on it a function called GetStatusAsync which returns a list of all the running orchestrations currently running on the task hub. This means we can do something like 

```csharp
var statuses = await starter.GetStatusAsync();
if (statuses.Any(x => x.RuntimeStatus == OrchestrationRuntimeStatus.Running && x.Name == "OrchestrationName"))
{
    log.LogWarning("An a running instance of the orchestration was detected. Terminating run.");
    return new HttpResponseMessage(System.Net.HttpStatusCode.Conflict);
}
```

This will prevent multiple instances of the orchestrator running. Note that we need to filter on orchestration name because it is possible the same task hub has multiple different orchestrations. 

Is this perfect? Oh heck no. There are lots of windows in which multiple orchestrations could be started. For my purposes, however, this works just fine. If your orchestrations are run more tightly than this then you might want to look at a distributed lock. My buddy Matt has a solution on the [Stackify blog](https://stackify.com/distributed-method-mutexing/) for this exact problem.