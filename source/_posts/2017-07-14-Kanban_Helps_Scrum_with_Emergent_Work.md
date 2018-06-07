---
layout: post
title: Scrum with Kanban Class of Service
categories:
  - Kanban
tags:
  - kanban
  - agile
  - scrum
  - myths
  - class of service
date: 2017-07-14 12:00:00
excerpt: Kanban's concept of Class of Service helps Scrum teams deal with emergent work
authorId: dave_white
---
Inspired by [Steve Porter's][1] efforts to bring process practitioners closer together and educate Scrum practitioners, I'm writing a shadow series of posts that will follow the [Kanban and Scrum - Stronger Together][2] series and continue [my own efforts][5] to clear up misconceptions between practitioners of these methods.

[In my last post][3], I discussed how a Scrum team could add the concepts of WIP limits to their process and derive measurable delivery performance benefits. In this post, I'm hoping to show how we can use Kanban's concept of Class of Service to help Scrum teams deal with emergent work.

## Emergent/Unplanned Work

One of the things that is very natural in Kanban but less so in Scrum implementations is the ability to deal with emergent or unplanned work during a Sprint. In this case, I am not talking about the anticipated, natural growth of a User Story or PBI as more information is discovered about it. I am talking about un-anticipated work such as emergency issues, newly discovered high-value opportunities, or newly understood schedule risks. 

I want to be clear that Scrum does not mandate that work cannot be introduced into the Sprint. The Scrum Guide allows for a negotiation to occur that would allow work to be introduce into the Sprint if there is capacity available, either by removing an existing PBI or by understanding that there is more room in the sprint than anticipated. In my experience, this does not come naturally to Scrum teams. Years of defending the Sprint backlog make this thinking hard to change.

But emergent and unplanned work are a reality for many knowledge work teams, especially in our DevOps world where increments of work are discovered, triaged, implemented, and deployed daily, if not many times per day. And as we will learn, this work can be easily tracked, analyzed, and we may be able to anticipate it.

## A brief Introduction to Class of Service

Before I get too deep, I wanted to present a description of Class of Service. 

> ### Description 
> A Class of Service is simply a policy that a team will explicitly create in order to guide team behaviour in scheduling and delivering an increment of work. They may take the form of rules for prioritization, swarming, or delaying the uptake of work by the team. There are 4 classic policy examples (Standard, Expedite, Due Date, Intangible) but you can create more or less. It is important to remember though that they are simply a policy which can be discussed, altered, or abandoned.

## Our First Class of Service

As a Scrum team, it is very easy to add your first class of service policy without any significant change to your Scrum practices. We will focus on a very common class of service policy, the **Expedite** class of service. This policy indicates that we have discovered work where the risk of delaying it is higher than we are comfortable with and we need to start a negotiation with the Product Owner about altering the Sprint Plan. We may also have to swarm on the work as a team because the impact of delay is severe. Instances of this type of emergent work happen often in DevOps scenarios where the development team is also responsible for problems that occur in the system in production. 

Our goal with trying out this minimum viable change to our Scrum process is to make expedite work very visible, make it very explicit, and try to understand how this risk mitigation policy is impacting our Sprints.

> **Note** - By creating an expedite Class of Service policy, we have actually created 2 Class of Service policies. Standard work (everything that is not expedited) and Expedite. Standard work is just _normal_ so we won't really discuss it further.

## The Expedite Lane

Keeping in mind our goal with this experiment, the first thing we want to do is simply make the Expedite policy and work visible, and we can easily do this with a simple change to our board. I will continue using our example board from the [previous blog post][3].

There are many ways that we can indicate that a work needs to be expedited. We could annotate a card, change its color, or put it in a special place on our board. To keep this simple and in the spirit of using boards, I'm going to suggest that we create a location on our board to indicate that we have an expedite policy and what work is currently affected by that policy.

![Scrum team's kanban board with Expedite policy depicted as a lane][6]

What you see in the image is a visualization of our policy that indicates:

- we have an explicit Expedite policy
- our policy is that we only work on one expedite item at a time
  - the swimlane has a WIP limit of 1 PBI

What is not clear on my board, but could be made clear with a Definition of Done (DoD) or similar annotations on the board, is 

  - expedited work is top priority
  - teams may be required to swarm to get that work done, which pauses all normally PBIs
  - work in the Expedite lane does not obey column WIP limits

We do not need to alter our cards in any way. Their presence in the lane indicates that the policy is being applied.

One additional change I would ask a team to make is that once a card enters the expedite lane and is now managed by the policy, mark the card/PBI with some sort of indicator that it was expedited. 

And that is it! We haven't changed how items get into that lane. We will still perform the negotiation with the Product Owner. We probably haven't changed our behaviour around emergent work, but we have made it clear that it is a reality for us and when something is in that lane, we are probably swarming on it if necessary to get it fixed before everything else.

### So Why Do this?

I would suggest using this technique to a team as a possible solution to a few problems.

1) There is not clear or commonly understood policy
2) There is a problem understanding/communicating when there is emergency work
    - in the team or external to the team
3) There is a problem understanding how much emergency work there is
4) There is a problem understanding how emergency work impacts our Sprint
5) There is a problem with the team not being designed to handle this kind of work

By understanding the problem that prompted the team to adopt this practice, we will understand if the practice is working and/or adding value and make adjustments as necessary.

## Early Benefits

Now that we have an explicit policy and we are tracking our expedited work, we can reflect on that work. 

We can look at how that work flows in conjunction with our normal PBIs and try to determine how one affects the other. Emergency work tends to be disruptive: we put down everything else, re-plan, negotiate, etc. All of these things add to the amount of time it takes for a team to deliver.  

With that information, we could re-design our work flow to minimize the impact of expedites on the PBIs in the original Sprint Plan. We could have a conversation with a sponsor to offload that type of work onto another team. Many opportunities, to design a system that satisfy all the types of work we need to do, can be explored with the information we know have because we are explicitly tracking emergent work.

And we may discover that while this work is not planned, it can be anticipated. And in anticipating it, we can more effectively deliver all of our work.

## What's Next

Those are just some of the opportunities that you have! I'm not suggesting you can't find those opportunities elsewhere, but you shouldn't be afraid to approach kanban! It will happily support the way you want to work today and help you continue your growth into the future!

By this point in the series, I hope that I've encouraged you to learn more about Kanban. And the best place to learn more is a certified training class from a LeanKanban.com Accredited Kanban Trainer. [You can find more about the recommended first class, Kanban System Design, here.][4]

In our next post, we will discuss how a Scrum team could enhance their understanding of how long it takes them to deliver a PBI by calculating a Lead Time!


[1]: https://www.scrum.org/user/119
[2]: https://www.scrum.org/resources/blog/scrum-and-kanban-stronger-together
[3]: http://www.westerndevs.com/Kanban/Scrum_with_WIP_Limits/
[4]: http://leankanban.com/kmp-i/
[5]: https://agileramblings.com/2013/03/10/the-difference-between-the-kanban-method-and-scrum/
[6]: https://i.imgur.com/WUKSbXn.png "Basic Scrum board with Expedite Lane"
