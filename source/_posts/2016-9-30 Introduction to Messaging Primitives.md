---
layout: post
title: Introduction to messaging primitives
categories:
  - C# 
date: 2016-09-30 17:00:00
tags:
  - C#
  - Messaging
excerpt: An introduction to messaging and the Primitives library to make writing message-driven/event-oriented systems easier.
authorId: peter_ritchie
originalurl: http://pr-blog.azurewebsites.net/2016/09/30/introduction-to-messaging-primitives/
---
#Introduction to messaging primitives

One of the most flexible design/architecture techniques is event-driven/message-oriented design.  It offers unparalleled ability to loosely couple, accomplish Dependency Inversion, facilitates composability, etc.  Message-oriented systems are by nature asynchronous.  This means that a message is sent and the process that sent the message continues on to do other processing without knowing whether the message was received by the other end.  Think of it like sending an email.  You send an email, close your email client, and go on to do something else.  Later, you may return to your email program and notice that the email you sent bounced.  But, you had to return to your email program to see that because you where asynchronously doing something else.

I've been working on an OSS project for a while that provides a framework for simple (once you wrap your head around the degree of loose coupling and asynchronousness) and flexible message-oriented design.  This framework is based on a small set of types that I call primitives.  Before going into what you can do with the framework, this post will first cover the primitives.

If you're used to message-oriented systems, some of this may be very understandable.  For those new to message-orientation, you'll understand why I started with the primitives.

The message primitives source code is on [GitHub](https://github.com/peteraritchie/Messaging.Primitives) and can be added to your Visual Studio project/solution from [NuGet](https://www.nuget.org/packages/PRI.Messaging.Primitives/) (but you may want to wait to add this package to your project/solution until a future post, as it's a dependency of the framework, so you don't need to add this package manually (i.e. it's referenced and NuGet will automatically get it for you).

The primitives are based on the most simple messaging building blocks (or patterns, which are well-defined in the book [Enterprise Integration Patterns](http://amazon.com/o/asin/0321200683/ref=nosim/enterpriseint-20) but can also be seen on [enterpriseintegrationpatterns.com/](http://www.enterpriseintegrationpatterns.com/)) and consist of a generic [Message](http://www.enterpriseintegrationpatterns.com/patterns/messaging/Message.html), a generic message Consumer, a generic message Producer, a generic [Pipe](http://www.enterpriseintegrationpatterns.com/patterns/messaging/PipesAndFilters.html), a generic [Command](http://www.enterpriseintegrationpatterns.com/patterns/messaging/CommandMessage.html) message (a specialized Message), a generic [Event](http://www.enterpriseintegrationpatterns.com/patterns/messaging/EventMessage.html) message (a specialized Message), and a [Bus](http://www.enterpriseintegrationpatterns.com/patterns/messaging/ControlBus.html).

##Message
The Message pattern is modeled in the Primitives via the `IMessage` interface, detailed as follows:
```csharp
	public interface IMessage
	{
		string CorrelationId { get; set; }
	}
```
The idea is that the message you want to send/receive implements this interface and you add the properties you need to contain the data.  The interface contains a property `CorrelationId` to provide a first-class ability to correlate multiple messages together involved in a particular interaction, transaction, or saga.  But, for the most part, you should use either Command or Event instead.
##Command
As mentioned above, you don't normally implement `IMessage` directly, you derive from one of two types of `IMessage`-derived interfaces.  The first interface I'll talk about is the `ICommand` interface.  This is a marker interface to add compile-time checked semantics that I'll detail in a future post, and detailed as follows:
```csharp
	public interface ICommand : IMessage
	{
	}
```
The [marker interface pattern](https://en.wikipedia.org/wiki/Marker_interface_pattern) is a pattern that allows associating metadata with a type.  In this case the metadata is the ability to differentiate at compile-time that a particular type is a Command.
The Command message pattern allows you to encapsulate all the information required to request a handler perform a command, or otherwise change state.  The type of command to be performed is the type of the `ICommand`-implementating class.  Message handlers should typically have no run-time state, so everything the command handler needs to perform the command should be included within the `ICommand` type.  For example, if I want to make a request to a handler to create a client, I may have a `CorrectClientAddressCommand` with the following detail:
```csharp
  [Serializable]
  public class CorrectClientAddressCommand : ICommand
  {
    public string CorrelationId { get; set; }
    public string ClientId { get; set; }
    public Address PriorAddress { get; set; }
    public Address Address { get; set; }
  }
```
As with marker interfaces, we have the ability to introduce metadata when we're defining our messages.  Just like something can be known as a Command because it implements `ICommand`, we can introduce more depth of intent in our messages.  For example, if a client moves, their address changes, but using a command like CorrectClientAddress does not include that intent.  We could create a new, identical command named "MoveClientCommand" that is effectively identical to `CorrectClientAddressCommand` in content (or even derive from the same base class).  And that way we can include semantic intent with the message.  Why would you want to do that?  In the address change example, when a client corrects their address they may never have received important mailings.  In the case of a correction, the organization can re-send important mailings.  In the MoveClientCommand you may not want to re-send all that information (waste of money, annoys clients, etc.) and instead send a card welcoming them to their new home and taking advantage of an opportunity to impress the clients.
##Event
The second message type pattern is an Event.  And just like an event we deal with in day-to-day life: it's a moment in time and information about that moment in time.  From the standpoint of messages, we say that an event is moment of time in the *past*, otherwise known as a fact.  It's important to remember that it's a past fact and really should be considered as immutable data.  Typically events model the details about a change in state. We model events in Primitives with the `IEvent` interface, with the following details:
```csharp
	public interface IEvent : IMessage
	{
		DateTime OccurredDateTime { get; set; }
	}
```
Notice that we force implementation of `IMessage` (that is, include `CorrelationId`) and add an `OccurredDateTime` property.
When we want to communicate an event, we call sending an event "publishing" the event.  This concept is considered "pub/sub" (or publish/subscribe) where something that publishes an event never knows how many subscribers (or if any) are subscribed to receive an event.  When utilizing event-driven in this way, we're very loosely coupled and any number of things can subscribe to these events and extend without affecting the sender (i.e. code changes or availability).
Typically, when we talk about what we model with events, or facts about the past, we model state changes and include information about that state change.  To correlate to the `CorrectClientAddressCommand`; upon a successful address change, the handler of that message may publish a `ClientAddressCorrectedEvent`.  Which may look like this:
```csharp
  [Serializable]
  public class ClientAddressCorrectedEvent : IEvent
  {
    public string CorrelationId { get; set; }
    public DateTime OccurredDateTime { get; set; }
    public string ClientId { get; set; }
    public Address PriorAddress { get; set; }
    public Address Address { get; set; }
  }
```
Circling back to the CorrelationId concept, the event includes the `CorrelationId` field.  If the event is published due to the processing of another message then we would copy that `CorrelationId` value into the event.  That way, when something receives the event (remember that messaging is asynchronous) it can correlate it back to another message, likely one that *it* sent.
##Consumer
Now that we have a grasp on some basic message types and concepts, lets talk about how we use those messages.
The thing that performs consumption or handling of a message is a Consumer.  It is modeled in the Primitives via the `IConsumer` interface, detailed as follows:
```csharp
	public interface IConsumer<in T> where T:IMessage
	{
		void Handle(T message);
	}
```
Notice that it's a generic interface and the generic type must implement `IMessage`.  The implementer of `IConsumer<in T>` must also implement a Handle method that takes in the an instance of the message that the class would process.  So, if I wanted to create a class to implement a handler for the `CorrectClientAddressCommand` command, it may look like this:
```csharp
  public class CorrectClientAddressCommandHandler: IConsumer<CorrectClientAddressCommand>
  {
    public void Handle(CorrectClientAddressCommand message)
    {
      // ...
    }
  }
```
Now, since we're using interfaces, a class can implement more than one handler.  For example, if I also wanted to process the ClientAddressCorrectedEvent, I may update my class to be something like:
```csharp
  public class CorrectClientAddressCommandHandler : IConsumer<CorrectClientAddressCommand>, IConsumer<ClientAddressChangedEvent>
  {
    public void Handle(CorrectClientAddressCommand message)
    {
      // ...
    }
    public void Handle(ClientAddressChangedEvent message)
    {
      // ...
    }
  }
```
But, as you can tell from the type of the handler class (`CorrectClientAddressCommandHandler`) that it's named very specifically to be a `CorrectClientAddressCommand` handler.  I typically use that convention and have one handler per class, which offers a greater flexibility in terms of loosely coupled and composability.  But, in the end, it's up to you what convention you'd like to use.
To write code to handle a particular message you simply implement `IConsumer<int T>` for one or more types of messages
##Producer
The thing that performs production of a message is called a Producer, and is model in Primitives as `IProducer<out T>`, detailed as follows:
```csharp
	public interface IProducer<out T> where T:IMessage
	{
		void AttachConsumer(IConsumer<T> consumer);
	}
```
Similar to `IConsumer<in T>`, except for the fact the generic type is covariant instead of contravariant, the generic type must implement `IMessage`.
Now this is where the loose coupling and composability takes us into an advanced realm.  You'll notice that the `IProducer` has a single method `AttachConsumer` that accepts an `IConsumer<in T>` where T is the same generic type as the producer.  This is probably very different from a typical imperative design that might have a method that returns a message.  We don't do it in an imperative way because 1) we have message consumption abstraction (`IConsumer`) and 2) the fundamental asynchronousness of messaging.  The production and consumption of messages does not occur in a consistent, sequential fashion such that we would know where to place a call to a method that returns a message.  Instead, we tell the producer who can consume the message and whenever the producer gets around the producing that message, it passes it right along to the consumer.
We may have a class that is a producer of `CorrectClientAddressCommand` and could define it as follows:
```csharp
  CorrectClientAddressController : IProducer<CorrectClientAddressCommand>
  {
    private IConsumer<CorrectClientAddressCommand> consumer;
    
    public void AttachConsumer(IConsumer<CorrectClientAddressCommand> consumer)
    {
      this.consumer = consumer;
    }
    
    public void CorrectClientAddress(Client client, Address newAddress)
    {
      if(consumer == null)
        throw new InvalidOperationException(
          "@nameof(consumer) was null during invocation of CorrectClientAddress");
          
      var command = new CorrectClientAddressCommand()
      {
        CorrelationId = Guid.NewGuid().ToString("N");
        ClientId = client.Id;
        PriorAddress = client.Address;
        Address = newAddress;
      }
      consumer.Handle(command);
    }
    //...
  }
```
Notice an application-/domain-specific method `CorrectClientAddress` that contains all the information required to send a `CorrectClientAddressCommand` (and the `CorrectClientAddressCommand` handler would perform the heavy lifting asynchronously and potentially in another thread/process/node, if you're looking for scalability).
You could use this class like this:
```csharp
  var controller = new CorrectClientAddressController();
  controller.AttachConsumer(new CorrectClientAddressCommandHandler());
```
And then when the `CorrectClientAddress` method is called, the consumer is invoked.
##Pipe
The last Primitive type is the Pipe.  The pipe is a general abstraction to model anything that is both a consumer and producer.  And, in fact, is just an interface that implements `IConsumer` and `IProducer`, detailed as follows:
```csharp
	public interface IPipe<in TIn, out TOut>
	  : IConsumer<TIn>, IProducer<TOut>
	    where TIn : IMessage where TOut : IMessage
	{
	}
```
With `IPipe` the consumer has a different generic type name than the producer, but, a single type could be used for both (`IPipe<MyMessage, MyMessage>`) to model a true pipe.
Typically though, we use `IPipe` to model various other messaging patterns like [Filters](http://www.enterpriseintegrationpatterns.com/patterns/messaging/Filter.html) (something that would ignore a message based on content) or [Translators](http://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageTranslator.html) (something that converts one message type into another message type).
##Bus
The next message pattern is the Bus.  A bus is modeled with the `IBus` type.  This bus model is basically facilitates implementing a Control Bus.  The Control Bus facilitates connecting message producers with message consumers in a more loosely coupled way.
Remember the `CorrectClientAddressController` `IProducer` example?  The code was tightly coupled to both `CorrectClientAddressController` and `CorrectClientAddressCommandHandler` and we had to new-up both in order to hook them up.  If I'm writing code that produces a message like `CorrectClientAddressCommand`, I don't want it to be directly coupled to one particular handler.  After all, we're looking for loosely coupled and asynchronous.  With tight coupling like that I might as well just do all the work in the `CorrectClientAddress` method and skip all the messaging.
A bus allows us to build up something at runtime that does that connection.  It will keep track of a variety handlers and invoke the correct handler when it consumes a message.
As you probably guessed, the `IBus` is a consumer and thus implements `IConsumer<in T>`.  But, a bus can handle a variety of different messages, so it uses `IMessage` for its type parameter, as detailed:
```csharp
	public interface IBus : IConsumer<IMessage>
	{
		void AddTranslator<TIn, TOut>(IPipe<TIn, TOut> pipe)where TIn : IMessage where TOut : IMessage;
		void AddHandler<TIn>(IConsumer<TIn> consumer) where TIn : IMessage;
		void RemoveHandler<TMessage>(IConsumer<TMessage> consumer) where TMessage : IMessage;
	}
```
As we can see from the definition of `IBus` is also allows the connection of pipes or translators.
So, if I wanted the type `CorrectClientAddressCommandHandler` to handle a `CorrectClientAddressCommand` (and produce a `ClientAddressCorrectedEvent` and a `ClientAddressCorrectedEventHandler` type to handle a `ClientAddressCorrectedEvent` message,  could use a mythical bus implementation `Bus` like this:
```csharp
  var bus = new Bus();
  bus.AddHandler(new CorrectClientAddressCommandHandler());
  //...
  bus.AddHandler(new ClientAddressCorrectedEventHandler());
  //...
```
I could then send the command to the bus and have the command handler handle the message and the event handler handle event, without ever specifically attaching one handler to the producer.  Sending that command could be done as follows:
```csharp
  bus.Send(new CorrectClientAddressCommand());
```
"So?", you may be thinking.  Remember when I spoke about how events are subscribed to, and how there may be more than one subscriber to an event?  I have a command handler than can only attach to one consumer, how would I be able to do that?  That's one of the benefits of the Bus, it deals with that for you.  If I added another event handler, I may create my bus as follows:
```csharp
  var bus = new Bus();
  bus.AddHandler(new CorrectClientAddressCommandHandler());
  //...
  bus.AddHandler(new ClientAddressCorrectedEventHandler());
  //...
  bus.AddHandler(new ClientAddressCorrectedEventHandler2());
  ///
```
The Bus would then handle forwarding the event to both of the event handlers, avoiding the need to write a different `IConsumer` implementation that would manually do that (e.g. a [Tee](https://en.wikipedia.org/wiki/Tee_(command))).
These are examples of composing in-memory buses. That is, they process messages within the same process (and in a specific order).

There's a couple of important concepts that relate to messaging.  Immutability and Idempotency.
##Immutability
I've already touched on immutability.  But, it's important to remember that due to the asychronous nature of messaging that you should consider the messages you send to be immutable.  That is, you should't change them.  For example, I could write some error-prone code like this:
```csharp
  var command = new CorrectClientAddressCommand();
  //...
  bus.Send(command);
  command.ClientId = 0;
```
In the case of a message that is physically sent to a queue (covered in a future post) that message has been serialized to the queue and has left this process.  Making a change to the `command` object cannot be seen by the consumer of that message.  If we're talking about an in-memory bus, it could be the same situation, but the time `Send` returns the message has already been processed.  If any of the message handlers are multi-threaded then the `command` object may or may not be already handled by the time `Send` returns.  In any case, it's best to view sent messages as immutable to avoid these race conditions.
##Idempotency
Another concept that often comes up in messaging is [Idempotency](https://en.wikipedia.org/wiki/Idempotence).  Idempotency is the quality of a message consumer to produce the same side-effects with the same parameters, no matter how many times it is invoked.
What I've detailed so far with in-memory buses is effectively Reliable Messaging.  If `IBus.Send` returns, the message was reliably processed.  When we start to include message queues and accept messages over the wire, running on multiple computers, we have to deal with the possibility that another server or process might fail and might have to re-send a message.  This typically only happens when the reliability settings of the Queue are not set to the highest level (for example "at-least-once delivery", where we trade performance for the potential that a message may be sent more once.  In situations like this you may want to send a message that allows the consumer be an [Idempotent Receiver](http://www.enterpriseintegrationpatterns.com/patterns/messaging/IdempotentReceiver.html).
In our `CorrectClientAddressCommand` we've effectively facilitated a Idempotent Receiver, no matter how many times I send a `CorrectClientAddressCommand` the resulting client address will be the same.  Other types of messages make it difficult to have an Idempotent Receiver.  For example, if I had an `IncreaseClientAgeCommand`, processing it would always increase an `Age` property of a client.  If at-least-once-delivery was configured for the queue, this could occasionally lead to incorrect ages.  You may want to either have a command like `SetClientAgeCommand` or better yet (avoid pedantry) and have a `CorrectClientBirthDateCommand`.

And with that, we have a good introduction of messaging and an intro to the messaging primitives library.  In a future post I'll detail the implementation of these primitives: the patterns library.
