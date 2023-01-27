---
title: Defining the Problem before the Solution
date: 2023-01-27T18:24:33.221Z
tags:
  - solution-architecture
  - problem-definition
  - requirements-gathering
  - defining-value
  - code
categories:
  - musings
originalurl: https://www.davidwesst.com/blog/defining-problem-before-the-soltuion
authorId: david_wesst
excerpt: Before you create a solution, you need to understand the problem. It
  sounds obvious enough, yet I see developers (including myself) getting into
  the code and design phase before they really understand the problem they are
  trying to fix. These are the steps I take a properly understand a problem I am
  trying to solve, prior to coding or solution-ing anything.
---

[1]: https://github.com/davidwesst/website/
[2]: https://www.davidwesst.com/talks/concensus-in-the-chaos/
[3]: https://www.davidwesst.com/talks
[4]: https://www.davidwesst.com/talks/cots-to-cloud/

Developers love to code.

I know this, because I am a developer. My heart constantly wants to code up the solution to...well anything. What I have learned over the developing and architecting enterprise software solutions, and as the solo developer of [my website project][1] is how this love of code can actually slow down and sometimes halt the development of a project or feature because we get too caught up in the tech, we don't take the time to reflect and solve the actual problem.

How do you fix this habit? Before you start coding up a solution, make sure you understand the problem you are trying to solve. Seems simple enough yet developers (like me) have the habit of jumping right into the code before they even really know what they are trying to solve. 

Through my years of experience solving problems with technology, I have a couple of steps I go through to help inform my solution design for problems of a variety of problems. I apply these steps when I am trying to figure out how to integrate two enterprise systems and when I'm trying to figure out the best way to implement a new feature on my website. 

The steps are the same, although the effort required will vary. 

# Understanding the Problem

And I don't mean coding problem. 

I mean _business problem_ or _real life problem_ or whatever you want to call it, but it's not a code problem. Never have I ever been asked by a client to "implement a binary tree" or "write a sorting algorithm for sorting an array". That's not to say those aren't problems, but they aren't _business problems_. These are technical problems, and they are fun to work on...sometimes. 😅

Business problems are the reason clients engage with software developers. The client wants software to fix their problem, and they seem to think that software is the solution. Before you code _anything_, take a few moments to answer the following about the problem you're preparing to solve with code.

## 1) Why is this a problem?

I am not suggesting you second guess the client, but rather try and empathize with your client and really understand why their problem is what it is. This is where you can start to understand whether or not software development fits into the solution to the problem. I have come across this many times, where after revisiting the problem with the client, we found the best solution was a change in their business process rather than adding tools to it.

Let's assume, for the sake of this post, that you see where software can help play a role in solving the problem.

## 2) What happens if we do nothing?

![An faded wooden sign that says the word "Nothing" in large blocky letters, set against a clear blue sky. Photo by Evan Buchholz on Unsplash.com](/images/2023-01-27-defining-problem-before-the-soltuion/nothing-sign.jpg)

Sounds silly, I know, but doing nothing is always an option and people do it all the time. But why would someone choose to do nothing? Because _the risk doesn't outweigh the reward_. 

By answering this question with your client, you get to understand the risks associated with the problem. This will inform your solution design, as if the risks are high you may want to invest more time and effort into parts of the design than others. It will also give you context on the priority of your solution in the mind of your client.

## 3) What KPIs or Success Metrics can your client define upfront?

The last thing I try to do is try and pull any key performance indicators (KPIs) or metrics that will help define success for the solution. I find that most of the time, this is about turning qualitative terms and statements into quantitative ones. 

For example, "We need to process these forms faster" should change to something like "We should be able to process at least 100 forms an hour". See the difference?

You are adding clear, measurable, success criteria for your solution. The terms "these forms" and "faster" are too vague to build on. Maybe fast enough to you is 1 form a day, oy maybe 1 form a second. Your client is the expert in their business, so you should ask them so you can understand the goals and potential constraints your solution needs to address.

# Redefine the Problem

I know-- your hands are itchy from not coding, but assuming you took the time to understand the problem, the next step is to confirm your new found knowledge. The easiest way to do that is by explaining it to someone else, like your client. If your client agrees you nailed it, you nailed it and now you're ready to start 
_designing_ (not coding) your solution.

One thing that is not uncommon is that your definition of the problem may sound different than the problem your client originally described. This is _normal_, as _you_ are the technology problem solving expert. 

The fact that your definition of the problem differs from your client's isn't necessarily a bad thing either. Many times, I have found that through my problem definition process, the client gains a better understanding of root cause of their problem and their mind will shift from their presumed solution, to something else. 

# Example: Adding Non-Blog Content to my Website

Let me walk you though the process on something not so enterprise-level, but small scale, like a solo-developed website project.

I hit a problem planning the next release of my website where I realized that it was going to be very complicated and cumbersome to add non-blog content to my website, such as the presentation materials from Prairie Dev Con [here][2] and [here][4]. At this point, here is what we know:

> 1) Client = Me
> 2) Problem = Adding non-blog content to the website is difficult.

Like a good developer, I immediately started down the path of designing a custom application that would automate all the things that make adding content difficult. It was very fun, but after a couple of hours, I caught myself and took a step back and applied my problem definition process.

Let's go through it, and we start by understanding the problem.

## 1) Why is it a problem?

It is a problem because I want to continue to add different types of content to the website. The whole purpose of the site is to create a central hub for all my work, almost like a portfolio, but more like a "hub" for all things I create a share. The website is built to handle blog posts or document style content, but when you add more complicated content that is made up of more than just an article or webpage, you need to add links to other data (like files) which is a manual process and is error prone.

In short, it is a problem because maintaining non-article data will be difficult.

## 2) What happens if we do nothing to solve the problem?

You can see in the [talks page][3] I have already added some non-article data, which is all currently managed through a JSON file that the website generator pickups and creates pages for. I also needed to upload the files to a public storage host (Azure Blob Storage) and use copy and paste the links into the JSON, which I messed up a few times. 

This was my first attempt at "doing nothing" for this problem, and it was difficult. The plan is to add the back catalogue of presentations I have done over the past 10 years (or more probably), which will make that JSON file exceptionally difficult to manage.

When you frame it in the context of risk: doing nothing will very likely result in an massive increase in the number of errors in the data. 

## 3) What KPIs can we use to measure solution success?

If we look at the original problem statement "Adding non-blog content to the website is difficult", we need to translate the term "difficult" into a quantitative one. This would give us a measure to determine how much easier it is to add new content.

Pulling from the answer to question 2, it's really managing the JSON file that makes things difficult. And so I asked myself (the client), what makes managing a JSON file so difficult? There are plenty of tools for that already. And this is where the _real problem_ revealed itself.

The relationships between the data leads to errors. Maintaining these relationships manually is exceptionally difficult, and we only have two relationships so far: presentation to event, and presentation to the presentation materials.

## Redefining the Problem

Now that we know the _real_ problem, we can redefine problem:

> Problem = The process of manually managing the relationships between content types and data is exceptionally error prone and not scalable.

This updated problem is one that will inform the solution design moving forward. If you want to get specific about the tech needed, we have a very powerful and mature tool that will help solve data relationships: a relational database. How it informs the solution, is a whole other blog post or posts, but at least now we _know_ what we are trying to solve and can use our technical expertise to solve it.

# Conclusion / TL;DR;

Before you start designing solutions or coding, take the time to clearly define the problem you are working to solve with your client (which can be you, if its your own project). To define the problem, answer these questions first:

1) Why is it a problem?
2) What happens if we do nothing to solve the problem?
3) What KPIs can we use to measure solution success?

Once you have that, redefine the problem by wording it in a way that highlights the root issue to solve, along with the way to measure success. Assuming the client agrees with your redefined problem, you are ready to start using the big, beautiful brain of yours and start solution-ing!

Thanks for playing.

~ DW

---

# Image Credit
- "Nothing Sign" Photo by <a href="https://unsplash.com/@vnbuchholz92?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Evan Buchholz</a> on <a href="https://unsplash.com/photos/z-Hu8pnt23s?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

