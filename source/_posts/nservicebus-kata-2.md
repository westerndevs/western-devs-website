---
layout: post
title: NServiceBus Kata 2
authorId: simon_timms
date: 2024-08-31
---

In the previous kata we sent a message from one application to another. This is a common pattern in messaging systems. In this kata we're going to look at a different pattern: publishing a message.

<!--more -->

# The Problem

It is great being able to send a message from one system to another - you can instruct a remote system to take some action which you don't know how to do. For instance sending an email. In a large system lots of processes will likely result in an email but if you can centralize the logic around how to send an email it makes it very easy to do things like change email providers as that functionality is isolated and independent. 

If you looked at my solution for the first Kata then you might have notice that I named my message `EatCake` this is named in the imperative form. This is a common pattern in messaging systems and is, I think, remarkably helpful to understand the command pattern. When you issue a command you know exactly who or what you're commanding and in the same way the command is sent to a known endpoint. 

Sometimes, however, you don't have a particular target in mind and you just want to let other systems know that you have done something. In this case you can publish a message. Unlike a command you don't know who is going to act on it - it may be nobody or it may be multiple people. In a messaging system we call this an `Event`. 

Let's extend our cake eating example to imagine some consequences of what might happen if I happily reported that I had eaten cake: `CakeEaten`. Finding out that the cake had been eaten the bakery might start baking more cake assuming that I'd want more (very likely). My gym might free up a treadmill knowing that my cake-induced guilt might drive me to run until I'd burned off the delicious butter-cream. It might also be of interest to my wife who can text me and see if I enjoyed the cake. I don't actually know who would be interested in the event so it is the responsibility of those who are interested to subscribe to the event.

# The Kata

Using the solution to the first kata as a starting point extend the system to publish a `CakeEaten` message. Subscribe to the message in the sender and write out a message to the console. Also create another new project similar to the others and have it subscribe to the message.

# My Solution

1. Create a new message in the messages assembly

```csharp
namespace messages;

using NServiceBus;

public class CakeEaten : IEvent
{
    public DateTime EatingFinishedAt { get; set; }
}
```

2. Modify the Hander in the receiver to publish the new event. Notice that we have access to a `IMessageHandlerContext` which we can use to publish messages.

```csharp
using messages;

public class PlaceOrderHandler :
    IHandleMessages<EatCake>
{
    public async Task Handle(EatCake message, IMessageHandlerContext context)
    {
        Console.WriteLine($"Cake eaten, NumberOfCakes = {message.NumberOfCakes}; Flavour = {message.Flavour}");
        await context.Publish(new CakeEaten
        {
            EatingFinishedAt = DateTime.Now
        });
    }
}
```

3. Modify the sender to subscribe to the event by adding a Handler to the project.

```csharp
using messages;

using NServiceBus;

public class CakeEatenHandler :
    IHandleMessages<CakeEaten>
{
    public Task Handle(CakeEaten message, IMessageHandlerContext context)
    {
        Console.WriteLine($"Uh oh, somebody ate a cake at {message.EatingFinishedAt}");
        return Task.CompletedTask;
    }
}
```

4. Optionally modify the sender to remain running so that it can receive the message. This is done by adding a `Console.ReadLine()` at the end of the `Main` method.

```csharp
using NServiceBus;

Console.Title = "NServiceBusKata - Sender";

var endpointConfiguration = new EndpointConfiguration("NServiceBusKataReceiver");

// Choose JSON to serialize and deserialize messages
endpointConfiguration.UseSerialization<SystemJsonSerializer>();

var transport = endpointConfiguration.UseTransport<LearningTransport>();

var endpointInstance = await Endpoint.Start(endpointConfiguration);

Console.WriteLine("Press Enter to exit...");
Console.ReadLine();

await endpointInstance.Stop();
```

Pause here and ensure that when running the sender and receiver that you see both a message sent and published.

5. Create a new project to act as a second subscriber or receiver

```
dotnet new console -o anotherReceiver
dotnet add anotherReceiver reference ../messages
dotnet add anotherReceiver package NServiceBus
```

6. Add a subscriber class to the project

```csharp
using messages;

using NServiceBus;

public class CakeEatenHandler :
    IHandleMessages<CakeEaten>
{
    public Task Handle(CakeEaten message, IMessageHandlerContext context)
    {
        Console.WriteLine($"Awesome, somebody ate a cake at {message.EatingFinishedAt}. Time to bake another");
        return Task.CompletedTask;
    }
}
```

7. Update the Program.cs to initiate NServiceBus

```csharp
using messages;
using NServiceBus;

Console.Title = "NServiceBusKata - AnotherPublisher";

var endpointConfiguration = new EndpointConfiguration("NServiceBusKataAnotherReceiver");

// Choose JSON to serialize and deserialize messages
endpointConfiguration.UseSerialization<SystemJsonSerializer>();

var transport = endpointConfiguration.UseTransport<LearningTransport>();

var endpointInstance = await Endpoint.Start(endpointConfiguration);


Console.ReadLine();

await endpointInstance.Stop();

```

Things to try now: 

1. Start the receiver and the another receiver then the sender - ensure you see messages flowing correctly
2. Start services in different orders and see which messages might be lost
 
Sending and receiving messages and publishing messages should now be working great. But to get this example going we've made some simplifications which we'll have to address in the next kata.