---
layout: post
title: JavaScript Framework or JavaScript Core (Part 2)
categories:
  - JavaScript
date: 2016-02-22 15:34:46
tags:
  - JavaScript
excerpt: Is it always better to use JavaScript Frameworks? David continues his analysys and shares the pros and cons of writing your JavaScript from scratch.
authorId: david_wesst
originalurl: http://www.webnotwar.ca/opensource/14136/
---

![][5]

A friend and I decided to make a video game using JavaScript.

When deciding on whether or not to use a JavaScript game framework [I went with Phaser][1], and [Chris opted to go with pure JavaScript][2].

We were both right.

In this series of posts, I want to explain how each of us answer the question: Should I use a JavaScript Framework or pure JavaScript?

This is part 2 of 2 in the series. In this post, I'll cover why I'll cover why Chris opted not to use any frameworks and stick with pure JavaScript. In [part 1][3], I covered why I opted to use a JavaScript framework rather than pure JavaScript.

##### Author's Note

Even though I'm talking about game development frameworks, the concepts and rationale discussed in this series of posts can be applied to any project (game, business, or otherwise) on whether or not you should use a JavaScript framework.

## Framing the Question

Let's frame this question in context to Chris' goals.

Like me, the game is a side project for Chris which means that it is important that he learn some new things along the way&nbsp;while still having the goal of "making a game". We both had these general learning goals:

* To learn how to draw using Canvas element
* To learn more about "graphics" programming in JavaScript
* To learn more about making games and game development

Chris, having less experience with JavaScript development than me, had the extra goal of:

* Learning more about JavaScript itself in the context of game development

This last goal is different than mine, although I could have easily made this one of my goals too considering there is always more to learn when it comes to JavaScript. Still, it is a difference that I wanted to note as we'll touch base on that near the end of this post.

## Why use Pure JavaScript?

The other side of the coin is to write your code from the ground up&nbsp;and rely on the native JavaScript APIs. In the case of Chris' game, he wrote code against the Canvas API to draw to the screen.

### Pros

As always, let's begin with the reasons why this was a good decision.

#### Deeper understanding of the Specification

Programming against the native API means that you'll understand the specification that everyone shares, including all of the frameworks out there. With this core knowledge, you can gain a better understand on how to fix or improve the frameworks themselves for your games moving forward.

Plus, you'll understand more about why things happen the way they do than those who just consume a framework.

#### Better Performance

![][6]

Learning the native APIs means that you're essentially programming "against the metal", or as close as you can come to it when you talk about JavaScript. Assuming you're writing efficient code, you are likely going to see some improved performance as compared to another game or application that is using a framework.

You will also not have to worry about Fast Food Frameworks bloating and bogging down your application on the web, as [Chris Love][4] would tell you.

#### Understanding Your Full Stack

Since you're writing against the native API, you will end up knowing all of your code from top to bottom because you'll have to write it all. This is an important consideration, as all software ends up with bugs. If you wrote all the code, then you'll have a good idea of where to look when it comes to triage and implementing fixes, improvements, or whatever.

### Cons

As always, there are drawbacks to any solution. Let's review a few of them.

#### Lack of Support and Guidance

When you select a framework, you're relying on the experience of many other developers who have poured their knowledge into building that framework. Hypothetically, these developers wrote the framework to make something easier for their own projects.

When you write all the code yourself, you rely on your own experience.That means&nbsp;if you don't have experience with certain architecture, patterns, or practices you're going to have to learn them quickly to figure out or possibly miss out on their benefits altogether because you simply don't know what you don't know.

#### Owning all the Code

When you own all of your code can be a bit of a double edged sword. Sure you own it all and ideally know it all inside out, but that means _you're the only one_ that actually knows it. Anyone else looking at your code, whether to provide support or contribute, is going to have a steep learning curve and rely heavily on you to learn how your code works rather than some documentation provided by a community of developers already sharing a code base.

Given, if you're a solo developer, that might not be an issue. But even in that case, you might not be able to remember the exact details about why you wrote some code a certain way 6 months after you wrote it.

#### Productivity

Any application, game or business apps, end up being made up of quite a bit of code to make sure all the features are implemented. Regardless of the benefits of owning all your code, the more code you have to write, the more time it's going to take before you get something up and running.

## So What Should You Choose?

Like I said before, Chris and I were both right in our respective decisions.

The reason for this&nbsp;is that both of us can explain the "why" we made the decision without having to convince ourselves that we were correct.

For your next project, you should choose what makes sense for you and your project goals. If you're looking to produce something as quickly as possible, it's probably best to pick a framework that can help you get moving faster.

If you're looking to learn or explore something new and need (or want) to know how the insides work, it's probably best to learn from the native APIs upwards, or possibly clone a framework and start modifying for your own needs.

Either way, if you ask yourself "why" you made the decision to go one way or the other and find that you need to convince yourself that you made the right decision, maybe it's time to rethink that choice before it's too late.

[1]: https://github.com/davidwesst/finder-game
[2]: https://github.com/chrinkus/walk
[3]: http://www.westerndevs.com/JavaScript/JavaScript-Framework-or-JavaScript-Core-Part-1/
[4]: http://love2dev.com/#!article/Large-JavaScript-Frameworks-Are-Like-Fast-Food-Restaurants
[5]: https://blog.davidwesst.com/2016/02/JavaScript-Framework-or-Pure-JavaScript-P2/js-framework-or-pure-js-p2.png
[6]: https://blog.davidwesst.com/2016/02/JavaScript-Framework-or-Pure-JavaScript-P2/performance-graph.png
