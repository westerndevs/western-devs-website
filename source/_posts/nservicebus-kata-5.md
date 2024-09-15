---
layout: post
title: NServiceBus Kata 5 - Timeouts
authorId: simon_timms
originalurl: https://blog.simontimms.com/2024/09/09/nservicebus-kata-5
date: 2024-09-09
---

In the previous kata we looked at sagas which are a way to coordinate long running processes. In this kata we're going to look at another tool in the NServiceBus toolbox: timeouts. Timeouts are a way to schedule a message to be sent at some point in the future. This is a powerful tool for building out complex processes.

<!--more-->

* Kata 1 - [Sending a message](https://www.westerndevs.com/_/nservicebus-kata-1)
* Kata 2 - [Publishing a message](https://www.westerndevs.com/_/nservicebus-kata-2) 
* Kata 3 - [Switching transports](https://www.westerndevs.com/_/nservicebus-kata-3)
* Kata 4 - [Long running processes](https://www.westerndevs.com/_/nservicebus-kata-4)
* Kata 5 - Timeouts
* Kata 6 - [When things go wrong](https://www.westerndevs.com/_/nservicebus-kata-6)

I think we're pretty used to the idea that a timeout is something we want to avoid - it usually means that a server isn't available or that we've run a query that is taking too long. But there are lots of places in business processes where timeout are just part of the process we're modeling and aren't an error at all. As an example consider a shopping cart: if a user adds an item to the cart and then doesn't check out within a certain period of time we might want to send them a reminder and even offer them a discount on their purchases. If we've modeled the checkout process as a saga then this reminder can be set up as a timeout.

# The Kata

We just implemented a cake order saga in the last kata. Let's extend that saga to include a timeout. If the cake isn't shipped within 2 minutes of the order being placed then we should send a message to the bakery to ask them to check on the order. Obviously 2 minutes is a pretty quick turn around on a cake but I don't imagine you want to hang around for hours writing this kata.

# My Solution

1. Add a new message to the messages project

```csharp
namespace messages;

using NServiceBus;

public class CakeOrderStalled : IMessage
{
    public Guid OrderId { get; set; }
}
```

2. Modify the saga to start a timeout when an order is placed. The CakeOrderPlaced handler becomes 

```csharp
public Task Handle(CakeOrderPlaced message, IMessageHandlerContext context)
{
    Console.WriteLine($"Order {message.OrderId} placed");
    
    return RequestTimeout<CakeOrderStalled>(context, TimeSpan.FromMinutes(2), new CakeOrderStalled{ OrderId = message.OrderId });
}
```

3. Add a handler for the timeout message

```csharp
public Task Timeout(CakeOrderStalled state, IMessageHandlerContext context)
{
    Console.WriteLine($"Order {Data.OrderId} stalled!");
    return Task.CompletedTask;
}
```

4. Have the saga implement 

```csharp
IHandleTimeouts<CakeOrderStalled>
```

4. We missed it previously but we need to have canceling the order or completing the order mark the saga as complete. To do that add `MarkAsComplete` to the handlers for those messages

```csharp
public Task Handle(CakeOrderCanceled message, IMessageHandlerContext context)
{
    Console.WriteLine($"Order {message.OrderId} canceled");
    MarkAsComplete();
    return Task.CompletedTask;
}
```

Things to try now

1. Run the applications and in the sender app try starting the saga with `o` to start an order. Wait a couple of minutes and see that the timeout fires.
2. Try starting the saga and then canceling it with `o` followed by `c` and see what happens when the timeout fires.

# Things to think about

Once a timeout is registered there is no way to cancel it. How come? What would you do if you needed to cancel a timeout? If messages are delayed is it possible that timeouts could fire when an expected action has actually happened? How would you mitigate that risk?

