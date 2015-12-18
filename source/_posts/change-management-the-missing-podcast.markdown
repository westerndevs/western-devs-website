---
layout: post
title:  Change Management - the Missing Podcast
date: 2015-08-15T10:29:50-06:00
categories:
comments: true
authorId: simon_timms
alias: /change-management-the-missing-podcast/
---

Some people are really good at computers. I am, apparently, not one of those people. This last Friday we had a fantastic podcast with

<!--more-->

- [Dylan Smith](http://www.westerndevs.com/bios/dylan_smith/)
- [Dave White](http://www.westerndevs.com/bios/dave_white/)
- [Simon Timms](http://www.westerndevs.com/bios/simon_timms/)
- [David Wesst](http://www.westerndevs.com/bios/david_wesst/)
- [Amir Barylko](http://www.westerndevs.com/bios/amir_barylko/)

However I managed to not record one second of it. I pressed record but apparently that is not sufficient to actually record it. As a form of penance I decided I would write up what I could remember from the talk. Thus:

We started by talking about Simon's post on [change management for the evolving world](http://www.westerndevs.com/change-management-for-the-evolving-world/). We talked about how we saw numerous advantages in moving quickly inside an organization. Dylan suggested that lag time between a feature being complete and not deployed is money wasted. If a need has been identified and addressed then not shipping it is costing the company. Dylan also introduced us to the idea of flow efficiency which is an idea taken from Kanban. It is a measurement of how much time a work items spends waiting for resources as opposed to actively being worked upon. In most organizations this efficiency is around 4% while in highly efficient kanban teams that efficiency is closer to 40% or even 50%. There is some inefficiency that is simply not possible to eliminate. 

David Wesst talked about how his large public sector company was facing challenges that could not easily be addressed by programmatically building infrastructure to test all changes. Many of the changes with which he was involved were related to ancient equipment that didn't have the capability of being virtualized or hardware changes. Change management is much larger that how we migrate changes to configuration or software. A change to a network switch or to a DNS entry cannot easily be modeled. As such having a change management review process was important because no one person could keep enough of the infrastructure in their head to understand all the impacts of the changes. In order to help with that the company with which Dave Wesst works had built a database which identified all of the interdependencies between applications and services. This system is to be kept fully up to date so that developers and admins have an easy place to check for the potential impacts of their changes. 

We identified that the change management meeting process was a bottleneck. The fact that the meeting happens only once a week and contains a great deal of very expensive talent was a problem. In order to be more efficient we struck upon the idea of taking the approval process out of a meeting and putting it into some sort of a workflow tool like SharePoint(yuck). In this way individuals could approve changes whenever they had time. This would not only provide a really good audit trail but also give an easy way to highlight where approval bottlenecks were. Dylan suggested that we all read the book [The Phoenix Project](http://www.amazon.com/The-Phoenix-Project-Helping-Business-ebook/dp/B00AZRBLHO). As a matter of fact Dylan suggested we read it no fewer than 10 times, so probably read it. 

Not all changes need to go through the full heavy weight process. There are, at least, two classes of changes: simple common place changes and complicated abnormal changes. The first category might be things like adding a new DNS entry while the second category could be things like upgrading a database. Clearly a big process would be detrimental to the first class of changes. Applying a single process blindly is not a good way to operate - instead apply some intelligence to how processes are created and adhered to. 

We also talked about how we can effectively audit software and configuration changes. An idea was that logging into a production system could require entering a ticket number. The session could then be recorded either through screen recording software on Windows or script(1) on Unix-like systems. Dylan also told us about a company where he worked that required that a low cost employee shadow any changes just to make sure that the person making the changes didn't deviate from what they were trying to do. 

In the end we decided that we had pretty much solved change management and that we all deserved huge raises and possibly knighthoods.
