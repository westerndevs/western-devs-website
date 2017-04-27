---
layout: post
title:  "Windows Server Containers Are Coming Whether You Like It or Not"
date: 2015-08-31T11:01:20-04:00
categories:
comments: true
authorId: kyle_baley
---

**UPDATE: April 27, 2017** Much of the information in this post is out-of-date and the links have been removed since they no longer exist.  For the latest on the state of containers on Windows, check out the [documentation](https://docs.microsoft.com/en-us/virtualization/windowscontainers/about/).

<!--more-->

After posting giddily on [Docker in the Windows world](http://www.westerndevs.com/docker-is-coming-whether-you-like-it-or-not/) recently, Microsoft released Windows Server 2016 Technical Preview 3 with container support. I've had a chance to play with it a little so let's see where this goes...

### It's a preview

Like movie previews, this is equal parts exciting and frustrating. Exciting because you get a teaser of things to come. Frustrating because you just want it to work *now*. And extra frustration points for various technical issues I've run into that, I hope, are due to the "technical preview" label.

For example, installing container support into an existing VM is mind-numbingly slow. Kudos to the team for making it easy to install but at the point where you run ContainerSetup.ps1, be prepared to wait for, by my watch, at least 45 minutes without any visual indication that something is happening. The only reason I knew something *was* happening is because I saw the size of the VM go up (slowly) on my host hard drive. This is on a 70Mbps internet connection so I don't think this can be attributed to "island problems" either.

I've heard tell of issues setting up container support in a Hyper-V VM as well. That's second-hand info as I'm using Fusion on a Mac rather than Hyper-V. If you run into problems setting it up on Hyper-V, consider switching to the <span style="text-decoration: line-through;">instructions for setting up containers on non-Hyper-V VMs instead</span> (no longer available).

There's also the Azure option. Microsoft was gracious enough to provide an Azure image for Windows Server 2016 pre-configured with container support. This works well if you're on Azure and I was able to run the nginx tutorial on it with no issues. I had less success with the IIS 10 tutorial even locally. I could get it running but was not able to create a new image based on the container I had.

### It's also a start

Technical issues aside, I haven't been this excited about technology in Windows since...ASP.NET MVC, I guess, if my tag cloud is to be believed. And since this is a technical preview designed to garner feedback, here's what I want to see in the Windows container world

#### Docker client *and* PowerShell support

I love that I can use the Docker client to work with Windows containers. I can leverage what I've already learned with Docker in Linux. But I also love that I can spin up containers with PowerShell so I don't need to mix technologies in a continuous integration/continuous deployment environment if I already have PowerShell scripts set up for other aspects of my process.

#### Support for legacy .NET applications

I can't take credit for this. I've been talking with [Gabriel Schenker](https://lostechies.com/gabrielschenker/) about containers a lot lately and it was he who suggested they need to have support for .NET 4, .NET 3.5, and even .NET 2.0. It makes sense though. There are a lot of .NET apps out there and it would be a shame if they couldn't take advantage of containers.

#### Smooth local development

Docker Machine is great for getting up and running fast on a local Windows VM. To fully take advantage of containers, devs need to be able to work with them locally with no friction, whether that means a Windows Container version of Docker Machine or the ability to work with containers natively in Windows 10.

#### ARM support

At Western Devs, we have a [PowerShell script](http://www.westerndevs.com/using-azure-arm-to-deploy-a-docker-container/) that will spin up a new Azure Linux virtual machine, install docker, create a container, and run our website on it. It goes without saying (even though I'm saying it) that I'd like to do the same with Windows containers.

#### Lots of images out of the gate

I'd like to wean myself off VMs a little. I picture a world where I have one base VM and I use various containers for the different pieces of the app I'm working on. E.g. A SQL Server container, an IIS container, an ElasticSearch container, possibly even a Visual Studio container. I pick and choose which containers I need to build up my dev environment and use just one (or a small handful) of VMs.

---
In the meantime, I'm excited enough about Windows containers that I hope to incorporate a small demo with them in my talk at [MeasureUP](http://measureup.io) in a few scant weeks so if you're in the Austin area, come on by to see it.

It is a glorious world ahead in this space and it puts a smile on this hillbilly's face to see it unfold.

Kyle the Barely Contained
