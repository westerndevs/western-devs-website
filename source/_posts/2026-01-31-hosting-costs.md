---
layout: post
title: Expensive Hosting for Small to Medium Projects
authorId: simon_timms
date: 2026-01-15
---

If you happened to read my previous post about [where AI is going](https://blog.simontimms.com/2025/12/24/where-is-this-ai-stuff-going/) then you might have picked up on my concerns about the rising cost of memory and compute. For the last few years any time I've recommened hosting to a client I've recommended some variant of AWS, Azure, or GCP. I've done this because I remember how painful it used to be to get a server allocated from an overstressed IT department. When I was on internship years ago for a large petro-chemical company we planned had to plan for deployment 6 or even 12 months in advance. IT had to figure out capacity and plan, plan plan. 

The cloud make this so much easier. We could spin up a server in minutes and with platform as a service we didn't have to worry about underlying compute or updates to operating systems, or patching. It was a dream. I'd tell clients "You're an insurance company leave being an IT company to Microsoft/Amazon/Google".

Recently though I've been looking at the cost of hosting an application in Azure. Even for our small applications it is surprisngly expensive. We had a tendency to vastly overbuild the hosting when for applications that have only hundreds or low thousands of users. What really gets us is the cost of the database. 

![](/images/2026-01-31-hosting-costs/2026-03-22-10-11-01.png)

This isn't a huge or highly performant database, but it is still costing us almost $400/month. For a small application with only a few hundred users this is a huge cost. Add on dev and test environments and the cost is even higher. Painful. 

I wanted to understand if I was still recommending the right thing to people so I started looking at alternatives. My first stop was looking at a VPS provider. I wanted something in Canada becasue this is where I live and I wanted to support local businesses. I found a provider called [OVH](https://www.ovhcloud.com/en-ca/) that had a VPS with 8 vCores, 24 Gig of memory and a 200 Gig SSD for $32 a month off contract. 

![](/images/2026-01-31-hosting-costs/2026-03-22-10-18-01.png)

Now obviously vCores aren't a standard measurement unit so it's hard to compares that with something from another offering like Azure but on the surface this feels similar to a D12 from Azure which is $380/month and that's in USD so closer to $500/month CAD. The OVH offering is about 1/15th the cost of Azure.

![](/images/2026-01-31-hosting-costs/2026-03-22-10-21-19.png)

Yikes! 

So I figured I'd sign up. Maybe the added cost here would be becasue it was really arduous to get signed up. I'll admit going through the process wasn't as polished as a cloud provier. Little things like this

![](/images/2026-01-31-hosting-costs/2026-03-22-10-28-27.png)

Is that a last name field or a field for people who only have a single name? Is Madonna buying hosting a frequently? The 2FA setup, though, was probably the best I've ever done. It had the really nice feature of letting you record the name of the app you were using for 2FA. I have multiple apps for 2FA and this is a really nice feature.

I did spot this warning, though

![](/images/2026-01-31-hosting-costs/2026-03-22-10-30-35.png)

Okay so there might be some latency in getting this server provisioned. That sucks, but perhaps I've gotten too used to the instant gratificaiton of demanding compute and getting it 5 minutes later. The email I got said that the server would be provisioned within the next 7 days. That's a long time to wait but whilte we do let's talk about why this VPS might not be a great idea. What are we losing by not using cloud hosting?

Well first off it's clear that scaling up and down is going to be so much harder. I can't scale the machine up instantly when there is a spike in traffic. Equally, if that spike subsites I can't scale down quickly. So I'm going to have to be comfortable knowing that I've got to pay for excess capacity. A lot of the line of business applications I work with have almost no traffic on the weekend and evenings but then predictable stable load during the day. I'm going to have to over provision to handle the maximum load. Maybe I can mine bitcoin or something on the weekends. Is that SETI@home project still a thing?

Next I'm losing the platform as a service benefits. I'm going to have to patch the operating system and database myself. I get to do backups, restores all that myself. So I'm going to trade my time for reduced hosting costs. Let's imagine that I'm setting up a database server and a web server which is kind of typical for a line of business application. This is going to run to $700/month in Azure(I'm going to use Candian dollars from here out). So that gives me $650 a month to play with for manual patching and updating and all that jazz. If I pay myself $200/hour (woo, massive pay raise) then I can spend 3 hours a month on that work and still come out ahead. I don't know if that scales well to dozens of servers but for a small application it might be worth it. 

I'm likely going to have an increased cost for the initial set up of the server. I've got to figure out which web server to use, probably some default settings for PostgreSQL and tie it into a build pipeline. I suppose we'll be deploying via SFTP or something like that. 

Finally, I'm losing the reliability and security of the cloud. I don't have the same level of redundancy and failover that I would get with a cloud provider. If my server goes down, it's on me to get it back up. If there is a security breach, it's on me to fix it. This is a big risk for any business, but especially for small businesses that may not have the resources to deal with these issues.

The other piece of the puzzle here is that the knowledge and expertise required to manage a VPS is higher than that required to use a cloud provider. I've been doing this computer stuff for year and I'm confident in my ability to teasily manage this but then I'm also still a bit sad about how Open Solaris failed to take off. I think that a lot of this gap can be closed using AI agents these days. 

It's a calculated risk. 

So, dear readers, I pulled the trigger and signed up for the VPS. Once it is provisioned then we'll return here and talk through setting up and deploying to it. 

