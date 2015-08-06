---
layout: post
title:  Microservices A Gentle Introduction
date: 2015-08-05T16:40:50+02:00
categories:
comments: true
author: donald_belcham
originalurl: http://www.igloocoder.com/2849/microservices-a-gentle-introduction
---

This past winter I started working on a project that was being architected with a mind towards using microservices. Prior to this I'd only seen the term 'microservices' floating around in the ether and really hadn't paid much attention to it. I wanted to share what we did and what I learned through the process and my subsequent research. That experience and research has led me to one belief: the microservice topic is massive. This post is going to be a kick-off to a series that will cover that material. With that, let's dig in.

##What are microservices?

Sometimes its easier to start by describing what something isn't. Microservices are not monolithic applications. That's to say our traditional application was one unit of code. It is:

* developed together (even split as multiple assemblies, it was developed as one codebase)
* deployed together (the vague promise of "just deploy one dll from the application by itself" has never been practical or practiced)
* goes through the full application lifecycle as one contiguous unit (it is built as one, maintained as one and dies as one application)

So a microservice is none of these things. In fact, to start the definition of what a microservice is you'd be safe in saying that, at a high level, microservices are the opposite of all these things. Microservices are a bunch of small applications that represent the functionality we once considered as one application. They are:

* developed in isolation (contracts between microservices are established but this is the extent of their knowledge of each other)
* deployed in isolation (each microservices is it's own encapsulated application)
* lives and dies no relationship to any other microservice (each microservice's application lifecycle is managed independently)

There's a pretty common comparison between microservices and SOA. If you missed the whole SOA bandwagon then 1) you're younger than me, 2) I'm envious of you, and 3) it had its merits. Some people will say "microservices are just SOA done right". I'm not sure that I fully agree with that statement. I don't know that I disagree with it either. As an introduction to microservices you should understand that there are many parallels between them and SOA. Applications that aren't monolithic tend to be distributed. Both SOA and microservice architectures are decidedly distributed. Probably the biggest difference between SOA and microservices is that SOA was quickly absconded by the big software manufacturing companies. According to them, doing SOA right meant using an Enterprise Service Bus (most likely an Enterprise Service Broker being marketed and pitched as a service bus)…and preferably using their ESB, not a competitors. Gradually those SOA implementations became ESB implementations driven by software vendors and licensing and the architectural drive of SOA was lost. Instead of a distributed system business logic was moved out of application codebases and into centralized ESB implementations. If you've ever had to debug a system that had business logic in BizTalk then you know what the result of vendors taking over SOA was.

Thus far (and microservices are older as an architecture than you probably think) the microservice architecture hasn't been turned into a piece of software that companies are flogging licenses for. It's questionable whether the hype (justified or not) around Docker as a core component of a microservices implementation is just the start of microservices heading the same direction as SOA. It might be, it might not be.

Each microservice is a well encapsulated, independent and isolated application. If someone pitches microservices at you and there's a shared database, or two microservices must be deployed in unison, or changes to one microservice forces changes on another then they're pitching you something that's not a true microservice. These concepts are going to lead to a bunch of the items I will discuss in future blog posts.

##What does all of this mean?

Good question. The short story, from what I've been able to collate, is that microservices promise a bunch of things that we all want in our applications; ease of deployment, isolation, technology freedom, strong encapsulation, extensibility and more. The thing that people don't always immediately see is the pain that they can bring. Most organizations are used to building and managing large monolithic codebases. They struggle in many different ways with these applications, but the way that they work is driven by the monolithic application. As we covered earlier, microservices are nothing like monoliths. The processes, organizational structures and even technologies used for monolithic applications are not going to work when you make the move to microservices.

Think about this: how does your team/organization deal with deploying your monolithic application to a development environment? What about to Dev and Test? Dev, Test and UAT? Dev, Test, UAT and Prod? I'm sure there's some friction there. I'm sure each one of those environment deployments takes time, possibly is done manually, and requires verification before its declared "ready". Now thinking about all the time you spend working through those environment releases and imagine doing it for 5 applications. Now 10. What would happen if you used the same processes but had 25 applications to deploy? This is what your world will be like with microservices.

Part of what I hope to convey in this series of blog posts is a sense of what pain you're going to see. There's going to be technical pain as well as organizational pain. And, as I know from experience over the last 6 months, there is going to be a learning curve. To help you with that learning curve I've created a list of resources as part of a github repository ([https://github.com/dbelcham/microservice-material] [1]) that you can go through. Its not complete. It's not finished. If you find something you think should be added please submit a pull request and I'll look at getting it added. As of the moment I'm writing this it's probably weakest in the Tooling, Techniques and Platforms section. I'm hoping to give that some love soon as it will be important to my writing.

##In closing

Microservices are a topic that is gaining traction and there's a lot of information that needs to be disseminated. I don't think I'm going to post any earth shattering new concepts on the topic but I want to get one location where I can put my thoughts and, hopefully, others can come for a cohesive read on the topic. I am, by no means, an expert on the topic. Feel free to disagree with what I say. Ask questions, engage in thoughtful conversation and tell me if you think there's an area that needs to be covered in more depth. 

[1]: https://github.com/dbelcham/microservice-material