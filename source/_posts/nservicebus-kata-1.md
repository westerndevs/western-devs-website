---
layout: post
title: NServiceBus Kata 1
authorId: simon_timms
originalurl: https://blog.simontimms.com/2024/08/30/nservicebus-kata-1/
date: 2024-08-30
---

Exciting times for me, I get to help out on an NServiceBus project! It's been way too long since I did anything with NServiceBus but I'm back, baby! Most of the team has never used NServiceBus before so I thought it would be a good idea to do a little kata to get them up to speed. I'll probably do 2 or 3 of these and if they help my team they might as well help you, too.

<!--more-->

* Kata 1 - Sending a message
* Kata 2 - [Publishing a message](https://www.westerndevs.com/_/nservicebus-kata-2/) 
* Kata 3 - [Switching transports](https://www.westerndevs.com/_/nservicebus-kata-3/)
* Kata 4 - [Long running processes](https://www.westerndevs.com/_/nservicebus-kata-4/)
* Kata 5 - [Timeouts](https://www.westerndevs.com/_/nservicebus-kata-5)

## The Problem

Our goal is to very simply demonstrate reliable messaging. If you're communicating between two processes on different machines a usual approach is to send a message using HTTP. Problem is that sometimes the other end isn't reachable. Could be that the service is down, could be that the network is down or it could be that the remote location was hit by a meteor. HTTP won't help us in this case - what we want is a reliable protocol which will save the message somewhere safe and deliver it when the endpoint does show up. 

For this we use a message queue. There are approximately 9 billion different messaging technologies out there but we're going to use NServiceBus. NServiceBus is a .NET library which wraps up a lot of the complexity of messaging. It is built to be able to use a variety of transport such as  RabbitMQ and Azure Service Bus.

We want to make use of NServiceBus and a few C# applications to demonstrate reliable messaging.

# The Kata

I like cake but I feel bad about eating it because it's not good for me. So in this kata you need to command me to eat cake. I can't refuse a command to eat cake so I can't possibly feel bad about it.

Create a sender application which sends a message to a receiver application. The receiver application should be able to receive the message and write it to the console. The sender application should be able to send the message and then exit. The receiver application should be able to start up and receive the message even if the sender application isn't running.

Now go do it!

Useful resources: 

* [NServiceBus getting started](https://docs.particular.net/tutorials/nservicebus-step-by-step/1-getting-started/)

# My Solution


1. Create a new directory for the project
```
mkdir kata1
cd kata1
```

2. Create a new console project for the sender
```
dotnet new console -o sender
```

3. Create a new console project for the receiver 
```
dotnet new console -o receiver
```

4. Create a new class library for the messages
```
dotnet new classlib -o messages
```

5. Add a reference to the messages project in the sender and receiver projects
```
dotnet add sender reference ../messages
dotnet add receiver reference ../messages
```

6. Add a reference to NServiceBus in all the projects
```
dotnet add sender package NServiceBus
dotnet add receiver package NServiceBus
dotnet add messages package NServiceBus
```

7. Create a new class in the messages project (and remove Class1.cs)

```csharp
namespace messages;

using NServiceBus;

public class EatCake: ICommand
{
    public int NumberOfCakes { get; set; }
    public string Flavour { get; set; } = "Chocolate";
}
```

8. Update Program.cs in the sender project to send a message

```csharp
using messages;
using NServiceBus;

Console.Title = "NServiceBusKata - Sender";

var endpointConfiguration = new EndpointConfiguration("NServiceBusKataSender");

// Choose JSON to serialize and deserialize messages
endpointConfiguration.UseSerialization<SystemJsonSerializer>();

var transport = endpointConfiguration.UseTransport<LearningTransport>();

var endpointInstance = await Endpoint.Start(endpointConfiguration);

await endpointInstance.Send("NServiceBusKataReceiver", new EatCake{
    Flavour = "Coconut",
    NumberOfCakes = 2 //don't be greedy
});

await endpointInstance.Stop();
```

9. Update Program.cs in the receiver project to be an endpoint

```csharp
using NServiceBus;

Console.Title = "NServiceBusKata - Reciever";

var endpointConfiguration = new EndpointConfiguration("NServiceBusKataReceiver");

// Choose JSON to serialize and deserialize messages
endpointConfiguration.UseSerialization<SystemJsonSerializer>();

var transport = endpointConfiguration.UseTransport<LearningTransport>();

var endpointInstance = await Endpoint.Start(endpointConfiguration);

Console.WriteLine("Press Enter to exit...");
Console.ReadLine();

await endpointInstance.Stop();
```

10. Add a message handler to the receiver project

```csharp
using messages;

public class EatCakeHandler :
    IHandleMessages<EatCake>
{
    public Task Handle(EatCake message, IMessageHandlerContext context)
    {
        Console.WriteLine($"Cake eaten, NumberOfCakes = {message.NumberOfCakes}; Flavour = {message.Flavour}");
        return Task.CompletedTask;
    }
}
```

Things to try now:

1. Run the sender project - it will send a message but the receiver won't be running so nothing will happen
2. Run the receiver project - it will start listening for messages and find the message which was left for it
3. Run the sender project again - it will send a message and the receiver will pick it up and write to the console

This demonstrates reliable messaging with NServiceBus
