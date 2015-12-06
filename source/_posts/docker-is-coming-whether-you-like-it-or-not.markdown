---
layout: post
title:  "Docker Is Coming Whether You Like It or Not"
date: 2015-08-04T08:31:10-04:00
categories:
comments: true
authorId: kyle_baley
---

I'm excited about Docker. Unnaturally excited, one might say. So much so that I'll be talking about it at [MeasureUp](http://measureup.io/) this September.

In the meantime, I have to temper my enthusiasm for the time being because Docker is still a Linux-only concern. Yes, you can run Docker containers on Windows but only Linux-based ones. So no SQL Server and no IIS.

But you can't stop a hillbilly from dreaming of a world of containers. So with a grand assumption that you know what Docker is roughly all about, here's what this coder of the earth meditates on, Docker-wise, before going to sleep.

### Microservices

Microservices are a hot topic these days. We've [talked about them](http://www.westerndevs.com/podcasts/podcast-microservices/) at Western Devs already and Donald Belcham has a good and active [list of resources](https://github.com/dbelcham/microservice-material). Docker is an eerily natural fit for microservices so much so that one might think it was created specifically to facilitate the architecture. You can package your entire service into a container and deploy it as a single package to your production server.

I don't think you can understate the importance of a technology like Docker when it comes to microservices. Containers are so lightweight and portable, you just naturally gravitate to the pattern through normal use of containers. I can see a time in the near future where it's almost negligent **not** to use microservices with Docker. At least in the Windows world. This might already be the case in Linux.

### Works On My Machine

Ah, the crutch of the developer and the bane of DevOps. You set it up so nicely on your machine, with all your undocumented config entries and custom permissions and the fladnoogles and the whaztrubbets and everything else required to get everything perfectly balanced. Then you get your first bug from QA: can't log in.

But what if you could test your deployment on the _exact same image_ that you deployed to? Furthermore, what if, when a bug came in that you can't reproduce locally, you could download the _exact container_ where it was occurring? NO MORE EXCUSES, THAT'S WHAT!

### Continuous Integration Build Agents

On one project, we had a suite of [UI tests](http://www.westerndevs.com/on-ui-testing/) which took nigh-on eight hours in TeamCity. We optimized as much as we could and got it down to just over hours. Parallelizing them would have been a lot of effort to set up the appropriate shared resources and configurations. Eventually, we set up multiple virtual machines so that the entire parallel test run could finish in about an hour and a half. But the total test time of all those runs sequentially is now almost ten hours and my working theory is that it's due to the overhead of the VMs on the host machine.

### Offloading services

What I mean here is kind of like microservices applied to the various components of your application. You have an application that needs a database, a queue, a search components, and a cache. You could spin up a VM and install all those pieces. Or you could run a Postgres container, a RabbitMQ container, an ElasticSearch container, and a Redis container and leave your machine solely for the code.

When it comes right down to it, Docker containers are basically practical virtual machines. I've used VMs for many years. When I first started out, it was VMWare WorkStation on Windows. People that are smarter than me (including those that would notice that I should have said, "smarter than *I*") told me to use them. "One VM per client" they would say. To the point that their host was limited to checking email and Twitter clients.

I tried that and didn't like it. I didn't like waiting for the boot process on both the host *and* each client and I didn't like not taking full advantage of my host's hardware on the specific client I happened to be working on at that moment.

But containers are lightweight. Purposefully so. _Delightfully_ so. As I speak, the overworked USB drive that houses my VMs is down to 20 GB of free space. I cringe at the idea of having to spin up another one. But the idea of a dozen containers I can pick and choose from, all under a GB? That's a development environment I can get behind.

---

Alas, this is mostly a future world I'm discussing. Docker is Linux only and I'm in the .NET space. So I have to wait until either: a) ASP.NET is ported over to Linux, or b) Docker supports Windows-based containers. And it's a big part of my excitement that **BOTH** of those conditions will likely be met within a year.

In the meantime, who's waiting? Earlier, I mentioned Postgres, Redis, ElasticSearch, and RabbitMQ. Those all work with Windows regardless of where they're actually running. Furthermore, Azure already has pre-built containers with all of these.

Much of this will be the basis of my talk at the upcoming [MeasureUP](http://measureup.io) conference next month. So...uhhh....don't read this until after that.