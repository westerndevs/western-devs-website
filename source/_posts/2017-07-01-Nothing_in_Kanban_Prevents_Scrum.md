---
layout: post
title: Nothing in Kanban Prevents Scrum
categories:
  - Kanban
tags:
  - kanban
  - agile
  - scrum
  - myths
date: 2017-07-01 20:00:00
excerpt: Inspired by a colleague 
authorId: dave_white
---
Inspired by [Steve Porter's][1] efforts to bring process practitioners closer together and educate Scrum practitioners, I'm writing a shadow series of posts that will follow the [Kanban and Scrum - Stronger Together][2] series and continue [my own efforts][5] to clear up misconceptions between practitioners of these methods.

# Kanban Easily Supports All of Scrum

One of the things that I see very often is a belief that Scrum and Kanban cannot work together and nothing is farther from the true. If we look at one of the core values of [The Kanban Method][6] you'll see that the first principle is:

> Start with what you do now

This should instantly put many change-fearing professionals at ease with regard to The Kanban Method, if not the practitioner helping you with it. But in this conversation, this should put Scrum team members at ease. There is nothing in the method that will disrespect your current practices or experiences.

[Yuval Yeret][4] has done a great job of giving us a [Primer to Kanban from Scrum Teams][3] but I thought I'd step back from that without introducing too much Kanban and try to diminish this fear that you can't do both by showing that it can be done easily. 

 One thing that a Scrum team would naturally want to do is understand the parallels or mappings between the two processes. Familiarity promotes comfort, so let's build a bit of a map for a _pure_ Scrum team to describe their approach in Kanban terms because generally speaking, Scrum teams are already **doing kanban**.

## Sprint/Iteration

One of the core tenants of Scrum is the Sprint. This time box is designed to give teams a few things:

1. consistent schedule for important, collaborative activities
1. control over work selection for the time period
1. meet daily to discuss current state and plan for the day
1. reduction in changes induced by external parties
1. an end date that the delivery team can use as a goal for delivery
1. an end date that a customer can use as an expectation

Scrum achieves these goals by using particular activities around and in the time box. As an example, let us say that a Scrum team has a 2 week Sprint, so at the start of a 2 week period, they replenish their sprint backlog in the Spring Planning meeting. They will select how much work to accept as the goal (Sprint goal/forecast) for the 2 week period. They will ~~not accept~~ _strongly discourage_ changes to the contents of the sprint backlog for the 2 week period. They will meet daily to discuss the current state of things and adjust any daily plans as appropriate. They will strive to complete the Sprint goal (all of the forecasted work) by the end of the Sprint, and they will plan to demonstrate their accomplishments to external parties in a Sprint Review. They will also plan reflect on their own activities and try to identify opportunities to improve their own capabilities in a Sprint Retrospective.

So what we've discovered is that:

1. They have a meeting at the start of the 2 week period to fill the Sprint backlog
   - the Scrum name: Sprint Planning meeting
   - The team chooses how much work goes into that backlog
   - The team will generally be allowed to finish that work before starting new work
1. They will meet daily to create effective daily plans
   - the Scrum name: Daily Scrum
1. They will have a meeting at the end of the 2 week period to review what they have produces
   - The Scrum name: Sprint Review
1. They will have a meeting at the end of the 2 week period to review their own process
   - the Scrum name: Sprint Retrospective

How do we model that in kanban? 

#### Cadences

... are the kanban term used to describe the things that happen on schedule. Kanban easily supports the Sprint Planning activity by creating an analogous cadence for a Replenishment activity, where the team interacts with an upstream partner (read: customer) to determine what to work on until the next time we get to meet with the customer. A Scrum team can easily describe their scheduled meeting as happening on predictable cadences.

1. Once every two weeks, we will collaborate to fill our backlog
   - a kanban name: Replenishment meeting
   - the team understand how much work will occur in 2 weeks
1. They will meet daily to discuss current state and plan for the day
   - a kanban name: Kanban meeting
1. Once every two weeks, we will meet to discuss/demonstrate what we've accomplished 
   - a kanban name: Product demo
1. Once every two weeks, we will discuss our own processes with an eye on improvement 
   - a kanban name: Service Delivery Review

#### WIP Limits

... are the kanban equivalent to picking (pulling) the work that we feel we can accomplish and being allowed to focus on finishing that work before starting or being interrupted by new work

A Scrum team picks how much work to pull into the Sprint. The kanban name for this is a WIP limit. A Kanban team can pull 10 PBIs into their process every 2 weeks. 

In Kanban, teams are not required to put WIP limits on columns. This is a natural growth path for many teams, but it certainly isn't required. A limit on the # of items accepted into the sprint is an acceptable form of limiting WIP. These limits are guides to optimal workflow behaviour, but they are not laws. Kanban teams, just like Scrum teams, can adapt their plan to accomodate newly discovered information.

#### Visualize

... is the kanban approach to using visualizations of intangible work (code, features, etc) to help us understand and manager our own process. We typically classify the things as _work items_ but they often have more descriptive names. 

Most Scrum teams already use boards and they use PBIs to describe intangible things like software and code. 


## Is there more

There is more to the Kanban Method, but we were just planning to model what a Scrum team does in kanban terms in a comfort-building exercise. Kanban does not require you to remove estimation (planning poker) as a means of filling your sprint. Kanban does not require you to abandon story points as a means of representing _size_ or _effort_. You can still use story points as a means of measuring _how much_ you did.

And that's it! Scrum teams visualize work, limit WIP, and have cadences! Any Scrum team can call themselves a Kanban team. They simply need to make the decision.

## What's Next

Well, if you are a new to Kanban team, there is lots of opportunity to grow. You have the opportunity to:

1. refine your understanding of your work
1. better know who your customers really are
1. understand what you do and how you do it
   - how we measure progress
   - how we maximize flow (team level)
1. who are your partners in your organization helping you deliver to your customers
   - how we maximize flow (organization level)
1. how we scale our approach across the organizations, not just multiple development teams
   - kanban in the HR dept. Who knew?!?! :D

Those are just some of the opportunities that you have! I'm not suggesting you can't find those opportunities elsewhere, but you shouldn't be afraid to approach kanban! It will happily support the way you want to work today!


[1]: https://www.scrum.org/user/119
[2]: https://www.scrum.org/resources/blog/scrum-and-kanban-stronger-together
[3]: https://www.scrum.org/resources/blog/kanban-primer-scrum-teams
[4]: https://www.linkedin.com/in/yuvalyeret/
[5]: https://agileramblings.com/2013/03/10/the-difference-between-the-kanban-method-and-scrum/
[6]: https://agileramblings.com/2013/04/07/kanban-change-catalyst-with-no-changes-planned/