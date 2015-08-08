---
layout: post
title:  Change Management for the Evolving World
date: 2015-08-06T18:51:52-06:00
categories:
comments: true
author: simon_timms
originalurl: http://blog.simontimms.com/2015/08/07/change_mangement_evolving/
---

I've had this blog post percolating for a while. When I started it I was working for a large company that has some internal projects I was involved with deploying. I came to the project with a background in evolving projects rapidly. It has been my experience that people are not upset that software doesn't work so much as they are upset that when they discover a bug that it isn't fixed promptly.

```
Velocity is the antidote to toxic bugs
```

Unfortunately the company had not kept up with the evolution of thinking in software deployment. Any change that needed to go in had to pass through the dreaded change management board. This slowed down deployments like crazy. Let's say that somebody discovered a bug on a Tuesday morning. I might have the fix figured out by noon. Well that's a problem because noon is the cut off for the change management meeting which is held at 5pm local time. So we've missed the change management for this week, but we're on the agenda for next week.

Day 7.

The change management meeting comes around again and a concern is raised that the change might have a knock on effect on another system. Unfortunately the team responsible for that system isn't on this call so this change is shelved until that other team can be contacted. We'll put this change back on the agenda for next week.

Day 14.

Change management meeting number 2. The people responsible for the other system are present and confirm that their system doesn't depend on the altered functionality. We can go ahead with the change! Changes have to go in on Fridays after noon, giving the weekend to solve any problems that arise. This particular change can only be done by Liz and Liz has to be at the dentist on Friday. So we'll miss that window and have to deploy during the next window.

Day 24.

Deployment day has arrived! Liz runs the deployment and our changes are live. The minor problem has been solved in only 24 days. Of course during that time the user has been hounding the team on a daily basis, getting angrier and angrier. Everybody is pissed off and the business has suffered.

##Change management is a difficult problem.

There is a great schism between development and operations. The cause of this is that the teams have seemingly contradictory goals. Development is about changing existing applications to address a bug or a changing business need. For the development team to be successful they must show that they are improving the product. Everything about development is geared towards this. Think of the metrics we might use around development: KLoCs, issues resolved, time to resolve an issue, and so forth. All of these are about improving the rate of change. Developers thrive on rapid change.

Operations, on the other hand, their goal is to keep everything running properly. Mail server need to keep sending mail, web server need to keep serving web pages and domain controllers need to keep doing whatever it is that they do, control domains one would assume. Every time there is a change to this system then there is a good chance that something will break. This is why, if you wander into a server room, you'll likely see a few machines that look like they were hand built by Grace Hopper herself. Most operations people see any change as a potential disturbance to the carefully crafted system they have built up. This is one of the reasons that change management boards and change management meetings have been created. They are perceived as gatekeepers around the system.

Personally I've never seen a change management board or meeting that really added any value to the process. Usually it slowed down deploying changes without really improving the testing around whether the changes would have a deleterious effect.

The truth of the matter is that figuring out what a change will do is very difficult. Complex systems are near impossible to model and predict. There is a whole bunch of research on the concept but it is usally easier to just link to

<iframe width="560" height="315" src="https://www.youtube.com/embed/n-mpifTiPV4" frameborder="0" allowfullscreen></iframe>

Let's dig a bit deeper into the two sides of this issue.

##Why do we even want rapid change?

There are a number of really good reasons we'd like to be able to change our applications quickly

1. Every minute spent with undesirable behaviour is costing the business money
2. If security holes are uncovered then our chances of being attacked increase the longer it takes us to get a fix deployed
3. Making smaller changes mean that when something does go wrong the list of potential culprits is quite short

On the other hand we have pushing back

1. We don't know the knock on effect of this change
2. The problem is costing the business money but is it costing more money that the business being shut down totally due to a big bug?

Secretly we also have pushing back the fact that the ops team are really busy keeping things going. If a deployment takes a bunch of their time then they will be very likely to try to avoid doing it. I sure can't blame them, often "I'm too busy" is not an acceptable excuse in corporate culture so it is replaced with bogus technical restrictions or even readings of the corporate policies that preclude rapid deployments.

If we look at the push back there is a clear theme: deployments are not well automated and we don't have good trust that things won't break during a deployment.

##How can we remove the fear?

The fear that ops people have of moving quickly is well founded. It is these brave souls who are up at oh-my-goodness O'clock fixing issues in production. So the fear of deploying needs to be removed from the process. I'm sure there are all sorts of solutions based in hypnosis but to me the real solution is

```
If something hurts do it more often
```
Instead of deploying once a month or once every two weeks let's deploy every single day, perhaps even more than once a day. After every deploy everybody should sit down and identify one part of the process that was painful. Take that one painful part and fix it for the next deploy. Repeat this process, involving everybody, after each deploy. Eventually you'll pay off the difficult parts and all of a sudden you can deploy more easily and more often. It doesn't take many successes before everybody becomes a believer.

##What do the devs need to do?
As a developer I find myself falling into the trap of believing that it is the ops people who need to change. This is only half the story. Developers need to become much more involved in the running of the system. This can take many forms:

- adding better instrumentation and providing understanding of what this instrumentation does
- being available and involved during deploys
- assisting with developing tooling
- understanding the sorts of problems that are faced in operations

Perhaps the most important thing for developers to do is to be patient. Change on this sort of a scale takes time and there is no magic way to just make everything perfect right away.

I firmly believe that sort of change management we talked about at the start of the article is more theatre than practical. Sometimes it is desirable to show management that proper care and attention is being paid when making changes. Having really good test environments and automated tests is a whole lot better than the normal theatre, though.

It is time to remove the drama from deployments and close the Globe Theatre of deployments.
