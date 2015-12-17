---
layout: post
title: "Microservice Sizing"
date: 2015-10-12 10:01:34 -0600
comments: true
authorId: donald_belcham
alias: /microservices-sizing/
---

As I mentioned in my last blog post ([Microservices and Boundaries](http://www.westerndevs.com/microservices-and-boundaries/)), I regularly see the question "How big should my microservice be?" The fast answer, albeit not the easy one, is that they should be the 'right' size. In that last blog post I talked about getting the right functionality into the right places (Antel for phone related functionality, Abitab for payment related functionality). There are a lot of people giving a lot of advise about scoping microservices, and I disagree with the majority of it. Here are some of the suggestions I've seen.

## One Week's Work
This scoping idea follows the premise that any microservice that you make should only take one week to write. There's no discussion about the difficulty of the task at hand, the proper encapsulation, what the bounded context is or what the velocity of your development team is. Without fail, every one of your microservices should fit into a work week.

My question is what if the work isn't done at the end of one week? I was once told that at that point you should throw it away and start over with a smaller scope. I'm not sure about you but to me that is about as wasteful as you could be. Run into a problem with a third party API that you can't get resolved in a week? Scrap that work and start again.

Don't think that what I'm saying is that we should allow our teams to take months to build microservices. We should be able to iterate on them quickly. This is one of the biggest benefits of taking the microservices approach. I think that the approach to writing your microservices should be one of Minimum Viable Product (MVP). If you write the bare minimum to have a functioning product, you will minimize the time spent on it. If the problem space is well bounded you will likely be working on microservices for very short periods of time. You shouldn't, however, set an arbitrary timebox as a means to scope the work.

## X Number of Lines
I can't count the number of times that I've heard/read "your microservice should be no more than X lines of code." Usually the value of X is absurdly small, even for the most terse programming languages. Common numbers I've seen thrown around are 250, 100 and 10. Yes, 10. Can you imagine trying to write a 10 line microservice that does everything that I explained that Antel was doing in my previous post? Of course not. You couldn't even write the business logic for that process let alone all the infrastructure code that would be required (transactioning, logging, diagnostics) to create a healthy and sustainable microservice (more on this in a future post).

Long ago we decided that LoC was a horrible metric for measuring anything to do with software development. Why would we introduce it again? The number of Lines of Code required for a microservice will only be known once all the functionality has been written. Sure, you might be able to shrink that count with some judicious refactoring, but you're not going to change 1500 lines of code into 100. If you can I'd suggest that you have a bigger cultural, or staffing, issue at hand.

## Two Pizza Team
I _hate_ this metric. I've seen it pop up in so many different discussions for so many different things. First, why pizza? Are we just a bunch of frat kids that haven't let our culinary preferences evolve? Second, have you seen the size of pizzas in some countries (looking at you United States of Gluttony)? You could feed a batallion with two large pizzas. Third, what if you can't decide on only two combinations of toppings? Sure you could get half-and-half done, but there's only so combinations you can request before the pizza joint hangs up on you.

More importantly I'd like to ask what does this metric prove? Focus on technical and team structure concerns when you think about that. The only thing that I can think of is that it could cap the size of the team. What does that mean for code? Lower overall velocity? Maybe, but that is probably more influenced by the quality of the individuals on the team.

## Summary
I'm a firm believer in working on microservices based on bounded contexts and minimum viable products. I don't need some catchy phrase telling me how I need to staff up my team or plan my work. Instead I know that I need to invest time into understanding my problem and setting expectations on the work.
Just like microservices aren't a panacea for software development, none of these are for sizing your microservices.