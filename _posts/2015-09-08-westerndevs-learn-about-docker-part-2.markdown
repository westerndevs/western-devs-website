---
layout: post
title: "WesternDevs learn about Docker - Part 2"
date: 2015-09-08 1:30:00
author: dave_white
originalurl: 
comments: true
---

##### Dislaimer
This blog post is to server two purposes. Act as a historical record of a conversation with a bunch of interesting links in context and to share a bit of an insider look at how conversations happen in the WesternDevs slack channels.

### Introduction
As Tom mentioned in his post about [Docker containers for Novices][1] which I'm considering Part 1 of this post, the WesternDevs had a conversation about how Docker containers work. A good portion of our group has a lot of experience in the Windows world and not a lot of *nix experience which is where containers seem to have been born from. 

One of the things that I love about WesternDevs is the fairly voracious appetite that all of us have to understand the various technologies that we use and talk about while also ensuring that the whole group understands. Leave no man behind while we learn I guess you would say.  

### The seed of the conversation
["Can AD, DHCP, DNS run in a container?" seems like an innocuous question][13], but it was the question that started the conversation.

Several of us started to posit that there are some thing (in a Windows world) that would be fundamentally required for a container to run and that maybe AD (identity) was one of those things. 

As often happens on Slack, someone says something that gets the rest of us disenting. It is usually [@dylansmith][2], which was the case this time. His statement (paraphrased) was that "Containers are like VMs so of course AD, DHCP, DNS, etc can run in containers." which several of us (myself included) disagreed with.  And thus began a very productive WD conversation.

So [@dylansmith][2] opened with "Containers are like VMs" and myself ([@davewhite][3]) responded with no, they are not, they are more like AppDomain than VMs. This set the stage for the two points of view in the conversation.

### What is a Container
The WesternDevs all agreed that Container's are a tool for isolation into consistent environments. [Tom's post][1] quite nicely summed up our thoughts. I don't think there was any disagreement amongst on that point. How containers achieved that was strongly debated and lead to a deeper understanding of what a "shared kernel" is. 

>Containers running on a single machine all share the same operating system kernel so they start instantly and make more efficient use of RAM.

A VM does not share a kernel with anything else, it shares physical resources with other VMs via the HyperVisor. 

We agreed that VMs give extra confidence in the level of isolation that is afforded the running applications. VMs do not afford the same level of performance as a container at start-up, and will consume more of the physical resources of the hardware that a comparable solution using containers.

### Windows vs. Linux
One of the things that underlied this conversation was the fundamental difference between the Windows kernel and Linux kernel. As far as we understand. the Windows kernel is big. Really big. And pulling all of the "user" stuff out of the "system" stuff will be very difficult for Microsoft and thus make containers on Windows ([which is coming whether you like it or not][4]) require a two-pronged approach, VMs that think they are containers and just pure containers. 

The Linux kernel is much smaller, providing basic resources to "user" modules. [@stimms][6] provided an awesome link to [ChimeraCoder][5] presentation about achieving Docker containers without Docker as some information on how the linux kernel works. The difference between [systemd][7] and a distro was nicely described in this presentation, and helped move the conversation a long.

This also helped us understand we could run different distros of linux in containers, as long as they all shared the same systemd version. You'd just install the distro of your choice in the container! Distros that didn't share the same kernel wouldn't be able to live side-by-side in containers on that host. Here is a great [SuperUser][8] post about this that helped as well as a [Docker article][9] about the underlying technology that Docker uses.

And Tom also shared that...
>But it’s the reason why Docker requires a VM to run on Windows or OS X. Neither of those have the proper kernel extensions for Docker to work properly.

### Throttling/Managing Container Resource Usage
After that, the conversation turned to managing container resources. If a container is using a hosts kernel, wouldn't that mean that a container could consume all of the resources of the machine/host without knowledge of any other containers? 

As it turns out, Linux already provides for this in the kernel. Linux has something called "cgroups" that can be used to group processes and [manage all kinds of resources][10]. This is how Docker (and probably all [systemd][7] based containers) works.

### What services does a host (Linux kernel) need to provide for a Container
With our core understanding of how Docker works rounding into consensus, we started to get back to the original question of what could run in a Windows container? [@topgenorth][11] to the rescue once again providing the group with a link to an introduction blog post on the [extensions that allow linux to create and manage containers][12].

We started with this list as a basis for discussing what might need to be shared by a Windows host to it's containers so that they could run. I don't think we have an answer on what all of the comparable Windows services are, but we have started to explore that question. 

### Wrapping up the Conversation
So in the end, we decided that a container was either an "AppDomain on steroids" or a "Dumbed down VM" and that we didn't know for sure what containers on a Windows Server would look like in the end. A VM clearly provides isolation over and above what is intended by containers and doesn't provide the performance benefits of using a shared kernel. But an AppDomain in itself doesn't provide the level of isolation, control, or repeatable environments that real containers and VMs can provide. 

### Final Thoughts
In the end as is very often the case, we decided that we were all right, we were all wrong, and that we had learned a lot during the conversation and we hope that you can share in our learning and new-found common understanding of how containers work and how they might work in a Windows world. 

[1]: http://www.westerndevs.com/docker-containers-explained-for-the-novice/
[2]: http://www.westerndevs.com/bios/dylan_smith/
[3]: http://www.westerndevs.com/bios/dave_white/
[4]: http://www.westerndevs.com/windows-server-containers-are-coming-whether-you-like-it-or-not/
[5]: http://chimeracoder.github.io/docker-without-docker/#1
[6]: http://www.westerndevs.com/bios/simon_timms/
[7]: http://chimeracoder.github.io/docker-without-docker/#9
[8]: http://superuser.com/questions/889472/docker-containers-have-their-own-kernel-or-not
[9]: https://docs.docker.com/introduction/understanding-docker/#the-underlying-technology
[10]: https://goldmann.pl/blog/2014/09/11/resource-management-in-docker/
[11]: http://www.westerndevs.com/bios/tom_opgenorth/
[12]: https://linuxcontainers.org/lxc/introduction/
[13]: http://codebetter.com/kylebaley/2015/09/01/windows-server-containers-are-coming-whether-you-like-it-or-not/#comment-2232115672