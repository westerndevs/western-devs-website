---
layout: post
title: Scrum with Kanban WIP Limits
categories:
  - Kanban
tags:
  - kanban
  - agile
  - scrum
  - myths
date: 2017-07-06 20:00:00
excerpt: A natural, easy first step for enhancing Scrum with a Kanban practice is a WIP limit
authorId: dave_white
---
Inspired by [Steve Porter's][1] efforts to bring process practitioners closer together and educate Scrum practitioners, I'm writing a shadow series of posts that will follow the [Kanban and Scrum - Stronger Together][2] series and continue [my own efforts][5] to clear up misconceptions between practitioners of these methods.

In my last post, I discussed how a Scrum team could change nothing about their process and organically start describing how they work in Kanban terms. In this post, I'm hoping to show a minimally viable change to their process that could lead to enhanced team delivery performance.

## Scrum's WIP Limit Policy

As we described last post, many Scrum teams limit work in progress (WIP) at the beginning of the Sprint by filling the Sprint Plan with work. The teams are given the ownership of deciding how much work to _pull_ into the sprint. In kanban terms, we would probably call this a [CONWIP (CONstant Work In Progress)][4] WIP control policy. We have constant WIP in the sprint, and we don't control WIP at individual stages of the workflow. One thing that Scrum teams will do that doesn't exactly fit with a CONWIP policy is that CONWIP policies normally just counts cards. In Scrum, cards are assigned a _relative size_ value (Story point) that describes the size of the card. So instead of having a CONWIP limit of 5 cards, Scrum teams will a CONWIP policy of 25 story points. That may be 3 cards, it may be 20 cards, depending on the nature of the work.

We're not going to change that at all. Limiting work in any manner is a **GREAT** start!

What we can do though is introduce count-based WIP limits at stages in the virtual kanban system. And that is it! Remember we are doing a minimum viable change to minimize risk, build experience and comfort, and see if this even works.

## Scrum is naturally enhanced by Kanban

Kanban practitioners usually strive to enhance the effect of the WIP limit policies on their system, constantly tuning them to get optimal performance. In order to do this, Kanban tends to promote more fine-grained WIP policies at the workflow stage level. This isn't the only place or way that we can use WIP policies, but it is a really great next step for a Scrum team to take. 

So very simply, the next step for Scrum teams to take is to put a WIP limit policy indicator at the top of a their kanban board!

Let's walk thorough an example and see how simple that would be!

### Scrum CONWIP policy controlled board

![Scrum Board with CONWIP policy][7]

We can see here that we are only controlling WIP for the entire system by limiting how much work can be pulled in per sprint. This is a great start to limiting WIP, but we might be able to improve the overall flow of work within the team's workflow. I have seen Scrum teams that start **everything** at the beginning of the sprint instead of starting only as much as they can handle and trying to finish that before starting a new story. Starting everything at once isn't good behaviour or encouraged behaviour in a Scrum team, but it happens without any other policies to guide team members to better behaviour.

### Scrum Board with Workflow Stage WIP control policies added

![Scrum Board with WIP Limits per stage policy][8]

We can see here that we have simply added some indicators of the WIP limit policy on the Kanban board. I just put a few sample numbers in place, but it is now clear what the policy is for the team with regard to pulling the work **through** the sprint and not just pulling work _into_ the sprint.

So what these numbers mean is that we believe that there should only be _n_ # of PBIs in a stage at once. Anything more is going to lead to emotional distress due to overburdening and probably slow delivery due to multi-tasking. Using these policies as an example, we believe we should only have 2 PBIs in analysis at a time and if someone is not busy in Dev and Test, they can help out with work on Analysis of a PBI to help flow work through the system.

It is also very important to understand that in the same way that the sprint capacity is determined during the Sprint Planning meeting and adjusted per sprint, these intra-sprint WIP limit policies should be adjusted when there is new information available about the capabilities of the team.

We also gain and share information about how we believe the team _should_ behave to help deliver PBIs more effectively. We can discuss work and policies instead of discussing people and why they are working a certain way.

And that is it! That is as easy as it is to add the idea of intra-workflow WIP limit policies to a Scrum team's kanban board. We didn't have to change anything about the way that we worked. We just enhanced and communicated our team's understanding of how we want to work.

## Did it Work?!?!

Before we call this experiment a success, we need to know, did this even work to improve our delivery capability?

If you're been practicing Scrum for a bit, you will have some historical information and hopefully trend data about your team's ability to deliver Story Points/PBIs to the customer. It is this information that we use in the Sprint Planning meeting to determine what our CONWIP number should be.

After you've implemented your intra-workflow WIP limit policies, doing nothing else, you should be able to detect if these policies helped you, or hindered you by measuring your Story Point/PBI delivery rate per sprint. You may also be able to capture some qualitative information in your Sprint Retrospective about the positive or negative impact of these policies on the team members.

If the experiment produced a measurable improvement in your team's ability to delivery, congratulations!! That is great news and I'd love to hear about it!

If the experiment produced _no_ measurable improvement in your team's delivery rate, congratulations!! You've discovered that it didn't work! And you have more information and I'd love to hear about it!  But if we had hoped to improve and discovered we didn't, we have a decision to make. Revert the changes as easily as removing the WIP limits from your board and continue life as it was before, or dig into why the policies didn't have the desired effect. Did you constantly exceed the WIP limits? Did you not measure all work? We know from experience that reducing WIP should improve delivery rates.

But again, if you don't want to figure that out, just remove the WIP limits from your board. Easy!

## Is there more

There is more to the Kanban Method and virtual kanban systems, but we were just planning to demonstrate a minimum viable change that gives Scrum teams a chance to try out a little kanban practice. Once we've mastered the understanding of WIP limits and their implementation, we can pick our next technique to start to learn about like demand shaping, kanban system designs that are fit for purpose, capacity allocations, managing emergent work, or any of the other practices that our community uses as we gain experience with Kanban.

## What's Next

Those are just some of the opportunities that you have! I'm not suggesting you can't find those opportunities elsewhere, but you shouldn't be afraid to approach kanban! It will happily support the way you want to work today and help you continue your growth into the future! 

In our next post, we will discuss how a Scrum team could enhance their practices to handle emergent (or emergency) work!


[1]: https://www.scrum.org/user/119
[2]: https://www.scrum.org/resources/blog/scrum-and-kanban-stronger-together
[4]: https://en.wikipedia.org/wiki/CONWIP
[5]: https://agileramblings.com/2013/03/10/the-difference-between-the-kanban-method-and-scrum/
[6]: https://agileramblings.com/2013/04/07/kanban-change-catalyst-with-no-changes-planned/
[7]: https://dl.dropboxusercontent.com/u/30830337/Basic%20Scrum%20Board%20With%20no%20WIP%20limits.png "Basic Scrum board with CONWIP policy"
[8]: https://dl.dropboxusercontent.com/u/30830337/Basic%20Scrum%20Board%20With%20Basic%20WIP%20limits.png "Basic Scrum board with WIP limits per phase" 