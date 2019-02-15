layout: post
title: Durable Azure Functions vs. NServiceBus Sagas
authorId: simon_timms
date: 2019-02-14 19:00
originalurl: https://blog.simontimms.com/2019/02/14/2019-02-14-durablefunctions_sagas/#more
---

I've been on a bit of an Azure Functions kick over the last little while. I've blogged a bunch on Durable Functions and deployed a bunch more. When you're as old as me then you tend to draw comparisons between new technologies and existing ones. For instance I'm constantly telling people about how web pages are a lot like the cave paintings I use to do in my youth. 

# The Twitter Exchange

The technology that draws the closest comparison I've seen to Durable Functions are NServiceBus Sagas. A few weeks ago I tweeted out wondering if any body had done a comparison. The good folks at Particular stepped up and answered. 

<!--more-->

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr">Recently <a href="https://twitter.com/stimms?ref_src=twsrc%5Etfw">@stimms</a> asked about comparisons between Azure Durable Functions and NServiceBus sagas. <a href="https://t.co/7sB5t9KMtH">https://t.co/7sB5t9KMtH</a></p>&mdash; Particular Software (@ParticularSW) <a href="https://twitter.com/ParticularSW/status/1085212877034844160?ref_src=twsrc%5Etfw">January 15, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

I'll reproduce the thread here so you don't have to click through and I'll add some comments.

<div style="background: #f3f3f3">
Before continuing, a quick disclaimer: Durable Functions are extremely new. We haven't fully assessed them yet. This is just a few engineers throwing thoughts against the wall. Our position is guaranteed to evolve over time. Now, on with the show…

There's definitely some similarities between durable functions and sagas. After all, an NServiceBus saga is essentially an NServiceBus message handler with durable state, and a durable function is an Azure Function with durable state.

One big difference is that a durable function is a non-message-bound orchestrator for other functions or processes. That means continuation of the durable function is driven by awaits, not by additional messages.
</div>

This isn't entirely accurate. You can trigger durable function continuations using external events https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-external-events but the mechanism is certainly less seamless than with NSB. You have to define a message handler and then raise the event. There is no nice way to find the running function like NSB does with Saga finding. https://docs.particular.net/nservicebus/sagas/saga-finding

<div style="background: #f3f3f3">
A very cool part about durable functions is that they automatically checkpoint their progress whenever the function awaits. Local state is never lost if the process recycles or the VM reboots.

But this behavior is not free and does have consequences! The orchestrator stores the history of its past executions in Azure Storage, then executes the ENTIRE function again from the BEGINNING, skipping awaits already finished in previous runs.
</div>

Yeah this is certainly something to be aware of. You need to be careful about how long orchestrations run for. There is a concept of eternal orchestrations but basically they throw away all the history and start over again. If you have a complex orchestration then you can break it up into sub-orchestrations. But again, this isn't as nice as NSB. 

One thing it does afford is the ability to rewind an orchestration and play it again. 

<div style="background: #f3f3f3">
So with durable functions you need to be careful that your orchestrator's implementation is deterministic. DateTime.Now, random numbers, Guids, etc. will get you into trouble! docs.microsoft.com/en-us/azure/az…

A Saga will typically focus on the interaction of one or two messages at a time. When thinking about a large process flowchart, one Saga will typically govern just the interactions at one point on the flowchart, not the entire process.

On the other hand, with a durable function, it's easy to have an entire process represented as one durable orchestrator function that can call other functions. This is both a strength (easily seeing the big picture) and a weakness (lots of coupling, can grow very complex).

Additionally, if you're trying to divide your system along service boundary lines (the vertical slices with independent databases mentioned in @MikhailShilkov's article) a giant orchestrator function covering an entire process flowchart makes this really difficult.
</div>
This seems like another place where sub-orchestrations could come into play. Probably a better approach is to have a Durable Function simply drop messages on a queue which will trigger other functions which may or may not be durable. This provides the logical separation similar to what you'd get with a series of sagas in NSB.

<div style="background: #f3f3f3">
A Saga on the other hand is a kind of "policy" object which statefully handles a few interrelated messages. It is completely isolated in its own vertical slice, and can communicate with other vertical slices in a lightly-coupled manner by publishing events.

The dangers of an all-encompassing durable function could be mitigated somewhat by doing all the real work in normal azure functions which are called from the orchestrator, and having the durable function be very lightweight, but this is a bit of a slippery slope.

Speaking of calling other functions, to do that you use the DurableOrchestrationContext's `CallActivityAsync<TResult>("FunctionName")`. This requires the use of "magic strings" for the function names, definitely not refactoring-friendly. https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-sequence
</div>

This is a limitation I've called out on twitter and in my durable functions talks. There are a few hacks you can use like leaning on `nameof` but they're not satisfactory. I've been working on a Roslyn Analyzer which will detect incorrect names, wrong parameters and broken return types. This is an addon nuget package, though, and not something that comes out of the box (unless I can convince the team to include it in the template). You can find it at https://www.nuget.org/packages/DurableFunctionsAnalyzer and eventually I'll get around to blogging the details.


<div style="background: #f3f3f3">
The capabilities of durable functions are impressive, but with an orchestrator function spanning multiple service boundaries and calling multiple other functions identified by magic strings in a command/control style, it would be VERY easy to end up with a distributed monolith.

Also, chaining functions together is itself a form of coupling, and this raises versioning challenges when changes to a system need to be made. https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-versioning

In NServiceBus a Saga is a stateful object with some Handle(message) methods on it where that state is persisted to a database. Even timeouts are represented as messages.
</div>
There is some really quite good unit testing advice at 
https://docs.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-unit-testing for Durable Functions but it certainly isn't as elegant as NSB's implementations. For complex orchestrations I think the tests would be quite hacky. 
<div style="background: #f3f3f3">
The messages are strongly-typed classes. No magic strings. Message comes in, stored state is read, make some decisions, message(s) come out. Easy to test, easy to refactor. https://docs.particular.net/nservicebus/testing/#testing-a-saga

And if anything goes wrong, the message rolls back to the queue and automatic retries kick in. This makes it easy for your system to recover from transient outages of databases or 3rd party APIs: https://docs.particular.net/tutorials/quickstart/#transient-failures

Also, when reproducing a bug in your system, having the actual messages which caused the failure in an error queue is a huge help, not to mention being able to "replay" them in production to complete the business process for your customer: https://docs.particular.net/tutorials/message-replay/
</div>

This I can't argue with. I've reprocessed thousands of messages in NSB and the ability to do so has saved the companies for whom I've worked thousands of dollars and avoided angry customer.

You can rewind durable orchestrations after correcting the problem. However the lack of an error queue is really tricky. The restful APIs to list orchestrations and their status and potentially rewind them aren't scalable or generally usable. There is a serious lack of tooling here (start up idea, alert!). 

<div style="background: #f3f3f3">
Of course, this wouldn't be complete without our real-time performance monitoring capabilities. Keep an eye on message processing time, retries, and queues backing up - resolving issues before they hurt the business: https://particular.net/real-time-monitoring
</div>

I am pretty confident that you could build the equivalent of Service Pulse and Service Control on top of durable functions. If you were building a serious production system on top of Durable Functions I think you'd have to build some tooling in this space. That should be a cost consideration when you do your analysis of technologies to use.

<div style="background: #f3f3f3">
But it's naïve to think that a system would have to be ALL sagas or ALL durable functions. Don't fall for the golden hammer fallacy, use each where it makes sense!

Azure Functions can be really great integration glue to bridge from various Azure Services like Blobs, Tables, Event Grid, CosmosDB, etc. to NServiceBus sagas and from there to your core business logic.

Azure functions are also great for small bits of infrastructure - we even recommend using them with NServiceBus to clean up data bus entries: https://docs.particular.net/samples/azure/blob-storage-databus-cleanup-function/

No matter what, remember that Azure Durable Functions are in their infancy. Going "all in" may not be the best bet. Start small.
</div>

This is totally accurate. I first used NSB in something like 2008 and even then it was a pretty mature product. Particular have built up a first class organization around NSB and you won't get better support anywhere. 

<div style="background: #f3f3f3">
Also keep "credit-card-driven development" in mind. Azure Functions billing is all about actual usage. @troyhunt runs the haveibeenpwned API for pennies because the function is ridiculously efficient. You have to design for that, or you might get a bill you didn't expect.

We’re still assessing Azure Functions, so if you are actively using them in production or even thinking about using them some day, we’d love to get your input! Leave your comments here: https://discuss.particular.net/t/azure-functions/872
</div>

# Other Aspects

No brief tweet thread can't quite capture the entirety of the comparison. Let me go through a few other thoughts I had about the comparison. 

## Platform Independence 

Durable Functions are highly coupled with Azure. This can be a good thing or a bad thing depending on your point of view. It speeds up development to have a lot of the decisions made for you already. Using existing Azure services together takes away from concerns about scalability and maintenance. However, if you ever need to migrate off Azure it would be a significant engineering effort. 

NSB on the other hand is an embarrassment of configuration options. You can use SQL transport, MSMQ, SQS, Service Bus and so on and so forth. You can host on windows hardware, on VMs, docker images on K8S on Linux or Windows. No matter your environment be it cloud or infrastructure based there is an NSB configuration which will work for you. There is an added burden of figuring out what the right solution is for your application. 

## Support

I don't think the support aspect of NSB should be ignored either. Certainly there is a support system in place for Functions but it isn't going to be as good as the support you'll get from Particular. On multiple occasions I've been able to chat with the actual developers of a feature of NSB at some length. I think that's something that any users of NSB could get. I've had some discussions with the Functions team but I think that that is really through the benefit of being an MVP and being kind of vocal about Functions. 

Cost is a factor too. I'm hesitant to bring this up because any cost comparison between free (which is Functions) and a paid product is bound to be one sided. You're going to have to pay for running your code one way or another. There isn't likely to be a huge price difference between running 10k messages through a cloud hosted NSB and Durable Functions. I could certainly see an advantage for early stage startups who can't afford the upfront licensing of NSB or for people in companies where buying licenses is harder than buying compute time on the cloud. On the other hand I think that the advantages of using a mature framework such as NSB offer huge advantages in reducing bugs and maintaining a production environment. 

## Code Structure

The message based paradigm of NSB is another advantage. You could write your Durable functions in a similar way to use concrete messages but boy is it tempting not to. I've found myself using a lot of tuples to chuck messages around which really I shouldn't. The constraints that NSB puts around messages are helpful in establishing good engineering practices. You can follow the same practices in Durable Functions but you'd need a strong code review culture and coding guidelines to keep you honest. There is an opportunity here for some Roslyn Analyzers or even a framework on top of Durable Functions. 

On the surface the await/async model of Durable Functions is really cool. The .NET Framework provides the syntactic framework for doing orchestrations so why not lean on it? Well because it is complicated looking. You end up defining your entire workflow in a single function and being able to trace though it in your mind is limiting. Message handlers let you focus on smaller parts of the system at a time which is helpful to those of us without giant brains. Any reasonably complex orchestration is liable to spread over 50 lines and to mix business logic and the plumbing of doing things like running fan-outs and chaining. 

## The Golden Hammer

Functions can be trigged though a lot of different mechanisms. One of those is HTTP which means you can run your entire web application inside of Functions. In the same project as your web API you can also put in place Durable Functions and they will just work. This provides a low friction way of doing background tasks or multi-step processes with checkpoints. But it also mixes a lot of code together and removes the nice separation of code you can get with deploying a bunch of NSB processes. At the moment I'm leaning towards the ease of being able to stand up Durable Functions inside your API code as outweighing the increased maintenance cost of mixing code up. However it is really something which we'll have to watch evolve as Durable Function products mature. 

## Scaling

Finally I wanted to talk about the ease of doing things like scaling out. Particular have done a lot of work around ethereal instance as of late but for the longest time the handler processes were treated much more like pets than cattle. That mentality is totally different in the land of Functions where you don't even know what hardware is being used. Being able to transparently scale up and down is really nice. 

# Shut Up Already and Tell me What to Use

I wish decisions were that easy. There are advantages to both systems and I'm sure I've missed a number of key aspects worth examining here. Durable Functions are great and I'm happy to see some competition for Particular who tend to fall very much on the slow and stable side of the spectrum as opposed to the move fast and break stuff side. Durable Functions have some growing up to do. The tooling around them isn't there yet and I don't expect that tooling is going to come out of Microsoft so much as it will come out of a vendor. 

If such tooling does emerge then you'll be back in the same boat as having to pay Particular for their product which does have an impact on the cost equation. 

If I were that ThoughtWorks Tech Radar thing then I would probably put Durable Functions in the `evaluate` quadrant while NSB would remain in the `adopt` quadrant. 