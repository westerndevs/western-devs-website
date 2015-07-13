---
layout: post
title:  Microservices, or "How to spread the love"
date: 2015-07-14T21:01:19-04:00
categories:
comments: true
author: kyle_baley
originalurl:
---

For some time, people have been talking about [microservices](https://www.nginx.com/blog/introduction-to-microservices/). I say "some time" for two reasons: 1) It's a good opening line, and 2) I have no clue how long people have been talking about them. I just heard the term for the first time about four months ago. So if I start talking about them now, while I still know virtually nothing, I can get at least two more future posts on the subject talking about how I was doing it wrong in the beginning.

In the meantime, I _have_ been talking about them quite a bit recently. We've been using them on a project at [Clear Measure](http://www.clear-measure.com) and I'd like to think it's been successful but it's too soon to tell. I feel good about what we've done which, historically, has always been a good metric for me.

The topic has been covered at a technical and architectural level pretty well by Martin Fowler, so much so that he's even collected his discussions into a nice little [Microservices Resource Guide](http://martinfowler.com/microservices/). In it, he and other ThoughtWorkians define them (to the extent that anything in software containing the word "services" _can_ be defined), point out pros and cons compared to monolithic applications, describe testing strategies, and cover off the major success stories in the space.

That doesn't leave much ground for me to cover which, from a marketing standpoint, is almost surely the point. But I would like to add my voice if for no other reason than to plug the [podcast](http://www.westerndevs.com/podcasts/podcast-microservices/) on the subject.

One of the more interesting links on Fowler's Resource Guide is tucked away at the bottom. It's a series of posts on how SoundCloud is migrating from a monolith to microservices. [Part 1](https://developers.soundcloud.com/blog/building-products-at-soundcloud-part-1-dealing-with-the-monolith) discusses how they stopped working on the monolith and performed all new work in new microservices and [part 2](https://developers.soundcloud.com/blog/building-products-at-soundcloud-part-2-breaking-the-monolith) is on how they split the monolith up into microservices. There were challenges in both cases, leading to other architectural decisions like event sourcing.

The arguments for and against are, predictably, passionate and academic. "Overkill!" you say. "Clean boundaries!" sez I. "But...DevOps!" you counter. "Yes...DevOps!" I respond. But SoundCloud's experience, to me, is the real selling point of microservices. Unlike Netflix and Amazon, it's a scale that is still relatable to many of us. We can picture ourselves in the offices there making the same decisions they went through and running up against the same problems. These guys have BEEN THERE, man! Not moving to microservices because they [have to](https://plus.google.com/+RipRowan/posts/eVeouesvaVX) but because they had a real problem and needed a solution.

Now if you read the posts, there's a certain finality to them. "We ran into this problem so we solved it by doing X." What's missing from the narrative is doubt. When they ran into problems that required access to an internal API, did anyone ask if maybe they defined the boundaries incorrectly? Once event sourcing was introduced, was there a question of whether they were going too far down a rabbit hole?

That's not really the point of these posts, which is merely to relay the decision factors to see if it's similar enough to your situation to warrant an investigation into microservices. All the same, I think this aspect is important for something still in its relative infancy, because there are plenty of people waiting to tell you "I told you so" as soon as you hit your first snag. Knowing SoundCloud ran into the same doubt can be reassuring. Maybe I'm just waiting for Microservices: The Documentary.

Regardless, there are already plenty of counter-arguments (or more accurately, counter-assumptions) to anecdotal evidence. Maybe the situation isn't the same. They have infrastructure. They have money and time to rewrite. They have confident, "talented" developers who always know how to solve architectural problems the right away.

So now I've more or less done what I always do when I talk microservices, which is talk myself into a corner. Am I for 'em or agin 'em? And more importantly, should **you**, reader, use them?

The answer is: absolutely, of course, and yes. On your current project? That's a little murkier. The experience is there and microservices have been done successfully. It's still a bit of a wild west which can be exciting if you ain't much for book learnin'. But "exciting" isn't always the best reason to decide on an architecture if someone else is paying the bills. As with any architectural shift, you have to factor in the human variables in your particular project.

For my limited experience, I like them. They solve one set of problems nicely and introduce a new set of problems that are not only tractable, but fun, in this hillbilly's opinion.

And why else did you get into the industry if not to have fun?