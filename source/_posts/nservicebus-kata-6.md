---
layout: post
title: NServiceBus Kata 6 - When things go wrong
authorId: simon_timms
date: 2024-09-14
---

So far in this series things have been going pretty well. We've looked at sending messages, publishing messages, switching transports, long running processes, and timeouts. But what happens when things go wrong? In this kata we're going to look at how to handle errors in NServiceBus.

<!--more -->

* Kata 1 - [Sending a message](https://www.westerndevs.com/_/nservicebus-kata-1)
* Kata 2 - [Publishing a message](https://www.westerndevs.com/_/nservicebus-kata-2) 
* Kata 3 - [Switching transports](https://www.westerndevs.com/_/nservicebus-kata-3)
* Kata 4 - [Long running processes](https://www.westerndevs.com/_/nservicebus-kata-4)
* Kata 5 - [Timeouts](https://www.westerndevs.com/_/nservicebus-kata-5)
* Kata 6 - When things go wrong

NServiceBus is built to be reliable. It is designed to be able to handle errors and to be able to recover from them. The most common reason for an error to show up in NServiceBus is that a message fails to process. This could be because the message is malformed, a resource which is needed to process the message is unavailable or because the handler throws an exception. Throwing exceptions in handlers is actually the preferred way to handle errors in NServiceBus.

When a message fails to process NServiceBus will attempt to reprocess the message. NServiceBus defines two different retry mechanisms: immediate and delayed retry. Immediate retries will reprocess at once and by default happen 5 times. Delayed retries fire at 10, 20 and 30 second after the failed retries and they too will fire immediate retries. So by the time a message has fully failed it's been attempted 20 times. If all these attempts fail then the message is shuffled off to an error queue. This error queue is not typically watched by NService Bus and recovering a message form it is a manual process. 

In NServiceBus installations I've worked on we monitor the error queues fairly closely and work to make the application resilient to errors such that the queues are only populated by messages which have failed due to resources being unavailable. Don't just ignore these messages as they are likely important user interactions or business processes which will cost you money if you don't address them.

# The Kata

Let's make one of our messages fail to process and watch what happens. In this scenario let's fail to properly sanitize our inputs to the messages and have them take on a value which makes no sense. We have a message `EatCake` which has a property `NumberOfCakes`. Let's make it so that the `NumberOfCakes` is set to -1 and that we have a validation in place in our message handler to throw when we see this problem. Let's also log a message so we can see the retries happening.

# My Solution

1. Modify the `EatCake` message hander to have a validation to make sure cakes are not eaten in the negative. 

```
public async Task Handle(EatCake message, IMessageHandlerContext context)
    {
        if (message.NumberOfCakes < 0)
        {
            Console.WriteLine("Negative cake? Really?");
            throw new Exception("Negative cake? Really?");
        }
        if (message.NumberOfCakes == 0)
        {
            Console.WriteLine("No cake to eat");
            throw new Exception("No cake to eat");
        }
        
        Console.WriteLine($"Cake eaten, NumberOfCakes = {message.NumberOfCakes}; Flavour = {message.Flavour}");
        await context.Publish(new CakeEaten
        {
            EatingFinishedAt = DateTime.Now
        });
    }
```

2. Modify the sender to send a message with a negative number of cakes

```
    switch (line)
    {
        case "send":
            await endpointInstance.Send("NServiceBusKataReceiver", new EatCake
            {
                Flavour = "Coconut",
                NumberOfCakes = -1
            });
            break;
            ...
```

3. You may need to configure the error queue in the receiver endpoint. 

```
endpointConfiguration.SendFailedMessagesTo("NServiceBusKataReceiverError");

```

And build the error queue using the handy dandy rabbitmq-transport tool

```
rabbitmq-transport endpoint create NServiceBusKataAnotherReceiver -c "host=localhost" --errorQueue NServiceBusKataAnotherReceiverError
```

Things to try now

1. Run the sender and produce some messages with negative numbers of cakes
2. Observe the logs for the receiver and see the retries happening
3. Wait a bit for the retries to be exhausted and see the message end up in the error queue
4. Open up the rabbitmq management console and look at the error queue. Pay special attention to the headers of the message. You'll see the number of retries and the time the message was first sent as well as the exception message.

# Things to think about

Looking at messages in the RabbitMQ management console is great for a single message but in the aggregate there is often a need for better tooling. Particular provide some tooling in the form of ServiceInsight which can be used to monitor the flow of messages through the system. This can be used to see where messages are failing and to help diagnose the problem. 

