---
layout: post
title:  Docker Containers Explained for the Novice
date: 2015-09-04T08:19:31-06:00
comments: true
authorId: tom_opgenorth
originalurl: http://www.opgenorth.net/blog/2015/09/02/docker-containers-explained-for-the-novice/
alias: /docker-containers-explained-for-the-novice/
---
Over at the [WesternDev](http://www.westerndevs.com/) "consortium" a random discussion broke out about _containers_: what are they, how are they different from virtual machines, and how do they work. While no means a "container expert", I have dabbled a bit and sought to add some clarity to the discussion. It seems that I made enough sense and so thought I would summarize the dicussion here.

 The whole idea behind containers is to isolate an application in a known environment. This helps prevent strange interactions with other software or libraries installed as well. I think [Docker](http://www.docker.com) has the best, concise description of what containers are:

> Containers running on a single machine all share the same operating system kernel so they start instantly and make more efficient use of RAM.

and

> ... containers wrap up a piece of software in a complete filesystem that contains everything it needs to run: code, runtime, system tools, system libraries – anything you can install on a server. This guarantees that it will always run the same, regardless of the environment it is running in.

So, while both containers and virtual machines provide isolation, they differ in how they do it. VM's will emulate the hardware; each VM thinks it's a computer with it's own CPU's, RAM, hard disk, kernel, etc. This isolation is provided by the virtualization host which runs on the hardware.

Containers, on the other hand, have a "host" that uses some kernel extensions to isolate software, but otherwise everything is running on the hardware. Containers share the host computer's RAM, CPUs, and even the kernel, however each container is secluded from the others and the host operating system. Because of this, containers can startup much faster and appear to be more responsive &ndash; they don't have to talk to a middle man to get access to the hardware.

Most modern Linux distros ship with somee [extensions](https://linuxcontainers.org) to support containers out of the box, so, in theory, you can just dive right and start creating containers without having to do anything extra on Linux.

In practice it's easier to use something like Docker to create and manage your containers. Docker also provides a way to share containers via [DockerHub](https://hub.docker.com/). You search DockerHub for something you need, like say [Mono](https://hub.docker.com/_/mono/), and then you grab the [Dockerfile](https://docs.docker.com/reference/builder/) (a recipe that tells Docker how to build the container), and away you go. Alternately, you can create your own custom Docker images based on an existing Dockerfile. It's kind of like subclassing a container, if you will.
