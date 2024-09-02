---
layout: post
title: NServiceBus Kata 4 - Long Running Processes
authorId: simon_timms
date: 2024-09-02
---

We now have a pretty solid way to send messages, publish messages and we've got those messages flowing over a reliable transport mechanism. Sending and publishing individual messages only gets us so far. We often need a way to coordinate complex processes which involve multiple services. For this NServiceBus has the concept of sagas which some might call process managers. 

<!--more-->

* Kata 1 - [Sending a message](https://blog.simontimms.com/2024/08/30/nservicebus-kata-1)
* Kata 2 - [Publishing a message](https://blog.simontimms.com/2024/08/31/nservicebus-kata-2/) 
* Kata 3 - [Switching transports](https://blog.simontimms.com/2024/09/01/nservicebus-kata-3)
* Kata 4 - Long running processes

Consider the bakery which is creating the cake for me to eat: when it starts making a new cake because I ate the last one it has a bunch of things it needs to coordinate. They need to preheat ovens, gather ingredients, mix ingredients, grease pans, fill pans, put pans in the oven, remember to take the cake out, cool it, ice it... the list goes on and on - no wonder cake is so expensive. Coordinating all these activities is complex in a distributed system, really in any system. There are a lot of corner cases that we usually fail to consider in a non-distributed system which become much more apparent when building out a process manager. What if we preheat the oven but then discover that we're all out of flour? In that monolithic system we might throw an exception and hope that somebody is monitoring for it in a log file somewhere. Realistically that's never going to happen. In the meantime nobody has shut the oven off and the bakery burns down. 

A saga allows us to store the state of a process, to react to messages as they come in and send new messages. We use this to coordinate the activities of the bakery. In our example above we can probably call the process "BakeCakeSaga". When messages come in relating to the order then we need to be able to find a way to look up the state and make modifications to it. NServiceBus implements this through a method called `ConfigureHowToFindSaga`. This function will provide a mapping from every message that interacts with the saga to find the saga data. For our example we'd probably use something like an order id. 

Let's build out a very simple saga which responds to just a few messages in our system so we can see how it works. Saga can get pretty complex but they are quite testable so that's nice.  

# The Kata

Create a saga which handles the messages `CakeOrderPlaced`, `CakeOrderCanceled`, `CakeOrderShipped`. Each of these messages will contain an `OrderId`, a GUID, which will be used to identify the saga as well as whatever information might be associated with those messages. For now just write out to the console when each of these messages is received - unless you want to bake me a cake which I will accept.

# The Solution

1. Add some mechanism to handle the persistence of saga data. For now we'll just use the in learning persistence. In the various program.cs files add 

```csharp
var persistence = endpointConfiguration.UsePersistence<LearningPersistence>();
```

2. Create messages classes in the messages project

```csharp
namespace messages;

using NServiceBus;

public class CakeOrderPlaced : IEvent
{
    public Guid OrderId { get; set; }
    public Guid CustomerId { get; set; }
    public Date OrderDate { get; set; }
}

public class CakeOrderCanceled : IEvent
{
    public Guid OrderId { get; set; }
    public string Reason { get; set; }
}

public class CakeOrderShipped : IEvent
{
    public Guid OrderId { get; set; }
    public string ShippingReferenceNumber { get; set; }
}
```

3. Create a saga class in the receiver project

```csharp
using NServiceBus;
using messages;
public class CakeOrderSaga : Saga<CakeOrderSagaData>,
    IAmStartedByMessages<CakeOrderCanceled>,
    IAmStartedByMessages<CakeOrderPlaced>,
    IAmStartedByMessages<CakeOrderShipped>
{

    protected override void ConfigureHowToFindSaga(SagaPropertyMapper<CakeOrderSagaData> mapper)
    {
        mapper.MapSaga(sagaData => sagaData.OrderId)
            .ToMessage<CakeOrderCanceled>(x => x.OrderId)
            .ToMessage<CakeOrderPlaced>(x => x.OrderId)
            .ToMessage<CakeOrderShipped>(x => x.OrderId);
    }

    public Task Handle(CakeOrderPlaced message, IMessageHandlerContext context)
    {
        Console.WriteLine($"Order {message.OrderId} placed");
        return Task.CompletedTask;
    }

    public Task Handle(CakeOrderCanceled message, IMessageHandlerContext context)
    {
        Console.WriteLine($"Order {message.OrderId} canceled");
        Data.OrderCanceled = true;
        return Task.CompletedTask;
    }

    public Task Handle(CakeOrderShipped message, IMessageHandlerContext context)
    {
        Console.WriteLine($"Order {message.OrderId} shipped");
        Data.OrderShipped = true;
        return Task.CompletedTask;
    }

}
```

4. Add a saga data class to the receiver project

```csharp
using NServiceBus;

public class CakeOrderSagaData : ContainSagaData
{
    public Guid OrderId { get; set; }
    public bool OrderCanceled { get; set; }
    public bool OrderShipped { get; set; }
}
```

5. Modify the sender project's program.cs to send the messages adding a loop which sends all the different messages involved in the saga. 

```csharp

bool continueMessages = true;
Guid orderId = Guid.NewGuid();

while (continueMessages)
{
    var line = Console.ReadLine();
    switch (line)
    {
        case "p":
            await endpointInstance.Publish(new CakeOrderPlaced { OrderId = orderId });
            break;
        case "c":
            await endpointInstance.Publish(new CakeOrderCanceled { OrderId = orderId });
            break;
        case "s":
            await endpointInstance.Publish(new CakeOrderShipped { OrderId = orderId });
            break;
        case "q":
            continueMessages = false;
            break;
        default:
            break;
    }

}
```

Things to try now

1. Run the applications and in the sender app try pressing some keys like `p` or `c` or `s` to see the messages being handled by the saga.
2. Try starting the applications in different orders and see how the saga handles the messages.

# Things to Notice

Notice that the Saga can be started by 3 different events. Why would a saga be started by a cancel message? You can't cancel an order which hasn't even been placed yet - right? Well it turns out you can. Without some serious hoop jumping through the order of message delivery it not guaranteed. So in fact orders can be canceled or shipped before we get the message telling us the order has been placed. It is sort of mind-blowing. 