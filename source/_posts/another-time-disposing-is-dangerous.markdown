---
layout: post
title:  Losing Data with Azure Blob Storage
date: 2019-08-15T23:30:00-05:00
categories: bugs
comments: true
authorId: justin_self
---

We had a bug that caused us to write 0 byte documents to Azure blob storage. It was there for a while. We tried hard to find it.

Eventually, we turned on blob snapshots which, instead of replacing a blob with a new blob on every write, makes a copy that you can promote at a later time. 

This week, we had a production issue where a blob had 0 bytes. We hadn't seen it in so long, we secretly hoped the problem was magically fixed by someone else.

<!--more-->

After promoting the previous copy, which unblocked the issue, I stared in frustration at the code, not understanding how we were writing to a stream with 0 bytes.

I probably spent an hour tracing through code and found no place where we were doing anything that would cause this issue. So I decided to take a walk... to the kitchen. There, I sat down with our CTO and described the situation. We started talking through scenarios of how this could happen. Maybe this was a bug in Azure blob or the SDK. Maybe it was our code. Maybe we were somehow purging the stream buffer.

After 10 minutes of ideas, we went back to my machine and started to take a closer look at the issue. First, we noticed the timestamps. We audit a lot of things in our system and we had an audit that occured just before the time we wrote the 0 byte document. We knew what time the write occured because of the timestamp on the document from the Azure Portal.

Working our way backwards, I filtered the logs looking for errors that may have occured before the timestamp or just after it. Then I saw a null reference exception in our logs just a little bit before our successful audit. The top of the stacktrace showed the null reference was actually coming from our IOC container attempting to inject a dependency. That was bizarre. We hold on to the containers for the lifetime of the service and that could be days. Even still, that shouldn't have had anything to do with writing a 0 byte document.

However, in an attempt to squash any leads, we dug a little deeper into the surrounding code where the exception was thrown.

A few layers above where the IOC call was eventually made, we see that we are attempting to get an instance of a class that helps us manage encryption. It was that class that was receiving the null reference exception and we happened to be doing that just before we write our data to the blob document.

That shouldn't have mattered because we had code like this:

            using (var stream = await blob.OpenWriteAsync())
            {
                //get factory here which gets stuff from IOC

                await stream.WriteAsync(data);
            }

We call `OpenWriteAsync` which returns a `CloudBlobStream` which inherits from `Stream`. We do some encryption stuff and then we write the data to blob. The "do some encryption stuff" is what was failing. Since this was wrapping in a `using` block, that means the exception was actually thrown in the compiler generated `try` block and then the `finally` block calls `Dispose` on the `CloudBlobStream` because it ultimately implements `IDisposable`.

We dug a little deeper into what `Dispose` was doing on the `CloudBlobStream`: it ends up calling `Commit` which, as you can guess, commits the data in the stream to blob. But, at this point we hadn't written any data. So it was actually committing an empty stream which created a 0 byte blob document.

But why were we through that exception to begin with? Well, we DO dispose the container when the Cloud Service instance is shutting down. So, that means we have to start shutting down a worker role (which is done via autoscaling or deployments) and begin processing a new message from our queue infrastructure within a very tight window. Then we will attempt to create a new encyption helper instance at just the right time before the role is down and that will lead to the disposed container which causes the exception. 

That, in of itself, shouldn't be a big deal. Our message goes back into the queue because it couldn't finish since the machine shut down. However, and without going too much into detail, we need to read data in the blob in order to know how we need to modify it. That means when we try to reprocess the message, it fails again because we don't have any of the data in the document that we should.

There are a couple of immediate takeaways from this that we are working through. First, we shouldn't have been doing anything inside of the `using` block other than what was purely necessary. We didn't need to do the encryption stuff in the using. If we hadn't we wouldn't have had an exception in a place where ultimately a commit would be called.

Second, we are considering putting the writes to the document in a separate message that isn't dependent on reading the document first. This would have let us replay the message and work the second time around.

To get around the issue right now (before we break things apart), we removed the `using` block all together and simply call `Dispose` ourselves when we are done. We've also removed anything between getting the stream and using the stream.