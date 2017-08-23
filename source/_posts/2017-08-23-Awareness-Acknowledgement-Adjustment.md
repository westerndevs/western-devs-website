---
title: Awareness, Acknowledgement, and Adjustment
date: 2017-08-23 09:00:00
category:
    - devops
tags:
  - devops
  - alm
excerpt: "There's a common pattern in IT that frequently leads to new buzzwords: Awareness, Acknowledgement, and Adjustment. Make it work for you!"
layout: post
authorId: damian_brady
originalurl: https://damianbrady.com.au/2017/08/23/awareness-acknowledgement-and-adjustment/
---

There's a common pattern in IT. In many cases, it ultimately leads to a new buzzword. It's not complicated. In fact it's fairly obvious. But *understanding what you can do with it* can help immensely when it comes to pushing change in your organisation.

Agile, DevOps, Microservices, Containerization, whatever the next buzzword is - all of these "revolutions" are really a result of these three steps.

> 1. Awareness

> 2. Acknowledgement

> 3. Adjustment

![You need awareness and acknowledgement before things will change](/content/images/2017/08/binoculars.jpg)

## Examples:

Let's look at a couple of examples to solidify what I'm talking about. I'm simplifying for the purposes of brevity, but consider Agile and Microservices:

### Agile:
1. *Awareness* of slipping timelines, incorrect estimates, project failures.
2. *Acknowledgement* that big, upfront plans never seem to go smoothly, no matter how long you spend on them or how many people are involved. Some things you just can't know until you start.
3. *Adjustment* of how projects are run - you can't plan for the long term, so let's just plan a short distance ahead and iterate.

### Microservices:
1. *Awareness* that even small changes can be expensive in a monolithic architecture, and side-effects can be hard to predict.
2. *Acknowledgement* that isolated and decoupled services can make change easier and more predictable.
3. *Adjustment* of how software is put together - small, self-contained components that can be iterated on more quickly.

**The same pattern can apply for DevOps:**

### DevOps:
1. *Awareness* that software in prodduction is the aim, and that there are some obvious bottlenecks that slow things down.
2. *Acknowledgement* that software should be able to help with this - most of what we do is able to be automated!
3. *Adjustment* by removing the bottlenecks using software and scripts, adding surety through automated testing, and reducing the cycle time from idea to production.

![](/content/images/2017/08/lightbulbs-hanging.jpg)

## So what can I do with this?

I've given a few talks lately on the challenges of implementing DevOps in an organisation where you have little to no control over how the business operates.

In particular, my "[Doing DevOps as a Politically Powerless Developer](https://vimeo.com/223984407)" talk has resonated with a lot of people lately.

As a "politically powerless developer" in an organisation, it can be difficult to instigate change, even when you know it's the right thing to do. In short, you probably don't have the power to implement the *Adjustment* part of this pattern.

**But you can definitely affect *Awareness*. It's easy - start measuring.**

![Make people aware there's a problem](/content/images/2017/08/ruler.jpg)

Measure how long it takes for a change you commit to make it to production. What happens in that time? Is there a lot of waiting?

Measure how long it takes for a user-reported issue to get to your backlog. Add some production monitoring, and measure how much time is saved by learning about issues first-hand. How much time did you save?

Measure the time it takes to write tests, and compare that to the time you take fixing bugs for code that doesn't have tests around it. Can you prove that writing tests is beneficial overall?

Once you have information, you can give it to your boss or pass it up the chain. You've already acknowledged there's a better way, so you'll be ready with solutions once management acknowledges there's a problem!

![Drive change by measuring and passing that information up the chain](/content/images/2017/08/report.jpg)

## Summary

To really instigate change and *adjust* how your organisation delivers software, there needs to be an *acknowledgement* that there's a problem. That won't happen unless there's *awareness*.

**If you're having trouble pushing change, focus on *awareness* first.**