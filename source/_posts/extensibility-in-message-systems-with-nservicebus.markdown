---
layout: post
title:  Extensibility In Message Based Systems With NServiceBus
date: 2016-06-28T21:30:00-06:00
categories: nservicebus
comments: true
authorId: justin_self
originalurl: http://www.justinself.com/extensibility-in-message-based-systems-with-nservicebus/
---
One of my favorite things about message based systems is the natural points of extensibility you can gain. Though, you don't get it for free if you aren't setting yourself up for it.

Let's say you work for a company that sells dog shoes online. Thinking about it, that's a dramatically under served market. 

Currently, your company's website allows for users to pay with their credit card and then, hopefully within a few days, receive their shoes. So let's take a look at some sample code for the handler that processes the message for payment.


    public class ProcessPaymentHandler : IHandleMessage<ProcessPayment>
    {
        public void Handle(ProcessPayment message)
        {
            paymentProviderClient.Charge(message.paymentData);
            //save and log response
        }
    }


Ok, obviously a simple example but you get the idea.

Everything is working well and your client's canine pals are having their paws covered in stylish footware.

## The New Requirement

Now your product owner comes to you with a new requirement: send a confirmation email once the payment has been processed. This is easy enough. Let's just have the ProcessPaymentHandler send a command to send the confirmation email.

    public class ProcessPaymentHandler : IHandleMessage<ProcessPayment>
    {
        public void Handle(ProcessPayment message)
        {
            paymentProviderClient.Charge(message.paymentData);
            //save and log response

            var emailAddress = customerRepo.GetEmailByOrderId(message.OrderId);
            bus.Send(new SendConfirmationEmail(emailAddress));
        }
    }

This is a common, albiet naive, approach to the problem. It will work, assuming we have a handler for the SendConfirmationEmail message to be received by, but there are some problems with it.

## Problems

### Dependency

The first problem is now the code that handles processing a payment has a dependency on the process that sends emails. This single line of code may not seem like a dependency problem, but maintaining code and clean architecture is a lot about managing dependencies. Introducing the command here forces the host of this handler to know about the location of the email handler.

 There's also a deployment dependency. We now have to keep this handler in sync with the current version of the email handler. 
 
 If the message interface changes because the handler was expanded or for any other of a multitude of reasons, we now have to come back and change code that handles processing a payment because some other code related to an email has changed (admittedly, though, we could effectively manage different versions in messages). Which leads us to the next problem...


### Single Responsibility

It's a violation of the Single Responsibility Principle (SRP) which basically means that a piece of code should have only one reason to change. The class is currently supporting two requirements (processing a payment and sending an email) therefore has two reasons to change.

### Open/Closed

In order for us to add a new feature, we had to modify existing code. Sometimes that's inevitable, but sometimes it's a sign of a series of preceeding bad design choices. When that happens, it is a violation of the open/closed principle. This principle states that you should be able to extend functionality without having to modify the internals of existing code.

What we want is the ability to complete the feature for sending the email without having to modify the existing code.

## The Solution - Events

If the ProcessPayment Handler published an event once it was done, then the Email Handler could subscribe to the event and take the appropriate action. This allows the payment processor to continue on its merry way being none the wiser that any process cares about it.

Here's the code for that:

    public class ProcessPaymentHandler : IHandleMessage<ProcessPayment>
    {
        public void Handle(ProcessPayment message)
        {
            paymentProviderClient.Charge(message.paymentData);
            //save and log response

            bus.Publish(new PaymentProcessed(message.OrderId));
        }
    }

In this code, we removed the line getting the email address and the code to send a new SendConfirmationEmail command.

It's pretty clear why the first line was removed. Since we aren't sending the command, we don't need to find the email address.

The second line, however, has some subtleties that could be missed. 

### Publish
The command was "sent" while the event is "published". Commands can be sent from N number of hosts but they are "sent" to a location because that location is always known. If a service has the contract and the correct queue, it can send any command it wants to. This means, however, that the service is now coupled to the processor of that command; being aware of its very existence is a coupling. 

However, events are published from one and only one logical host but can be received by N number of hosts. Other services can subscribe to those events without the publishing service being aware of it. This inverts the coupling the other direction. The service that needs to do the action is now coupled to the service that publishes the event. The coupling here makes sense. In our case, the email service wants to know when it needs to send the confirmation email. So, we can allow it to couple to the PaymentProcesssor service.

If you are still not quite groking events vs commands, try this: 

* Commands are like email. You know who is going to read it and you know where it is going. You send the email to one person with the expectation that they will read it and act on it.

* Events are like this blog post. I have no idea if anyone will read it, who that person is or where they are located. I put it out in case anyone is interested in my data.

I want to reiterate something really quickly: Anyone can send a command, but there must be only **ONE** service that handles it. Anyone can subscribe to an event but there must be only **ONE** service that publishes it.

### Naming
The event is named as a past tense version of the command it was being published from. This is a convention I pretty much always use when naming commands and events. The commands are imperative. They represent actions your services can do and generally found in your ubiquitous language. The events are past tense. If your command name is "DeleteAccount" the event would be "AccountDeleted".

Here's some sample code for handling the event:

    public class PaymentProcessedHandler : IHandleMessage<PaymentProcessed>
    {
        public void Handle(ProcessPayment message)
        {
            bus.Send(new SendConfirmationEmail());
        }
    }

You may have noticed I'm sending a command from this event handler instead of just doing the work. There is a reason and I'll get to why I did that in another post.

## Extensibility

Up to now, all we've really done is changed a command to an event and moved some logic to the event handler, which then delegates to another command handler. So where's the power in that? 

*Queue the Product Owner*

Now we have some new requirements. Once a payment has been successfully processed, if this is a first time customer then the company wants to send out a special dog treat to the customer to give to their canine companion as a thank you for their business. So let's add that capability.

If we didn't have events, we would need to modify the existing code for processing a payment and have another command sent (which introduce more of the three problems from earlier). However, since we have events, all we need to do is let this catalogue service subscribe to the PaymentProcessed event and do its thing. This means we don't have to modify ANY code in the Payment Processor.

    public class PaymentProcessedHandler : IHandleMessage<PaymentProcessed>
    {
        public void Handle(ProcessPayment message)
        {
            bus.Send(new SendPhysicalCatalouge());
        }
    }

We just extended the application without modifying any existing code. That's the power of using events. If the company decides they also want to add the customer to a list for someone to call and thank them personally, we could subscribe to the event again. If the company decided they no longer wanted to send dog treats, then we simply unsubscribe to the event. 

All of this is done without redeploying the current, existing code (PaymentProcessor).

## Under The Hood
When you add a subscription to a host, NServiceBus actually sends a message from the subscribing host to the publishing host. This informs the publishing host that the subscribing host wants a copy of the event when it is published. This gets stored in whatever persistence you previously chose: (Azure Storage, SQL, MSMQ, etc). This is true for all persistences except when you are using Azure ServiceBus or RabbitMQ because they both native pub/sub capabilities and hold onto the subscription data.

## TL;DR
In order to allow for extensibility and prepare for future features, every command should have a corresponding event to go with it. With NServiceBus, if no one has subscribed to the event, then nothing will happen so there's no overhead of adding the events to the handler.