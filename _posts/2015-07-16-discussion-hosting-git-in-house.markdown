---
layout: post
title:  Discussion: Hosting git in-house
date: 2015-07-16T08:46:11-04:00
categories: slack,discussion
comments: true
---

We had a good discussion on Slack recently on getting a client up and running with Git. For many, the decision boils down to: GitHub or BitBucket. In this case, the repositories need to be stored in-house. Thus sparking the first debate.

### In-house vs. hosted

Despite the strong cultural shift, some companies are still wary about having assets stored in frozen droplets of water floating in the atmosphere. Hosting in-house feels safer. What if GitHub goes down? What if VSO gets hacked? WHERE IN THE &*%$# IS MY DATA?!?

There's a psychological aspect to hosting yourself that's related to these fears. If it's on your server and it goes down, that's on you, the organization. And in many organizations, they can shoulder that blame better than if a provider goes down or comes under attack. In fact, in some respects, the more incompetent your IT department, the easier it is to bear the burden of downtime as the users will be accustomed to it. (Side note: it would be interesting to see if there's a correlation between an IT department's effectiveness and whether they host their own source code.)

In-house source code hosting can be done, obviously. It *has* been done for years. But with the proliferation of online options, there are considerations to...ummm...consider. The cost of setting up and maintaining a production-grade git server for one thing. This is your source code so it can't be running on a cast-off laptop in the basement. It needs a proper back-up schedule complete with testing the restore process. Uptime will be important as will latency. The server must be supported by the entire IT infrastructure, not just a couple of developers who know git. That means it has to be considered during OS upgrades and patches.

This isn't meant to deter people from hosting in-house but to outline the variables when you're deciding whether to do it. There remain good reasons whereby the cost of doing it yourself is mitigated by other factors. Legal requirements of where the data resides, perhaps. Or a staunch corporate/government policy that will cost too much to rebel against.

### Windows/Linux

Another constraint: no Linux. This is a tough one and we wrestled with it quite a bit. Ignoring the legitimacy of the constraint, we discussed a few options. [Bonobo](https://bonobogitserver.com/) for one. It's an open-source Git server written in C# that runs in IIS. That sentence alone was enough to give us some pause. Not that we're against open source C# web projects. But through "git" in there and it starts to sound more like the result of someone's weekend thought experiment.

Problem is: there aren't many other options once you remove Linux from the equation. It is apparently possible to [host git repositories on a Windows server directly](http://blog.chronosinteractive.com/posts/using-windows-server-host-git-repository). If you read through the steps though, it seems like you may as well be doing it on Linux.

At one point, we gave serious consideration to running a git server on Docker on Windows. Until someone pointed out the obvious: for the time being, at least, it's still a Linux VM behind the scenes.

GitHub for Enterprise will [install on Windows](https://help.github.com/enterprise/2.2/admin/guides/installation/installing-github-enterprise-on-hyper-v/). But only on Hyper-V. And they don't make it clear but this strongly suggests that it's on a VM, almost certainly Linux. They also provide an image for VMWare.

That leaves [BitBucket's Stash](https://www.atlassian.com/software/stash/). It requires a JVM and TomCat but looks very much like it meets the "Windows only" server criteria. That said, we also have anecdotal evidence that it is a considerable drain on resources.

### The "winner"

In the end, given the constraints, we settled (begrudgingly) on TFS as the best solution. It runs on Windows and hosts git. TFS comes with its own issues, not least of which is the cost. Whether or not that cost offsets the perceived "benefit" of hosting in-house remains to be seen. But that is now a business decision rather than a technical one.