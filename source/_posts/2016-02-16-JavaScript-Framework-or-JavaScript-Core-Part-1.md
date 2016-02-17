---
layout: post
title: JavaScript Framework or JavaScript Core (Part 1)
categories:
  - JavaScript
date: 2016-02-16 15:34:46
tags:
  - JavaScript
excerpt: Is it always better to use JavaScript Frameworks? David analyzes the pros and cons of using JavaScript frameworks versus only using core JavaScript.
authorId: david_wesst
originalurl: http://www.webnotwar.ca/opensource/13996/
---
![js-framework-or-pure-js][1]

A friend and I decided to make a video game using JavaScript.

When deciding on whether or not to use a JavaScript game framework [I went with Phaser][2], and [Chris opted to go with pure JavaScript][3].

We were both right.

In this series of posts, I want to explain how each of us answer the question: Should I use a JavaScript Framework or pure JavaScript?

This is part 1 of 2 in the series. In this post, I'll cover why I opted to use a JavaScript framework rather than pure JavaScript. In part 2, I'll cover why Chris opted not to use any frameworks and stick with pure JavaScript.

##### Author's Note

Even though I'm talking about game development frameworks, the concepts and rationale discussed in this series of posts can be applied to any project (game, business, or otherwise) on whether or not you should use a JavaScript framework.

## Framing the Question

To better understand my decision, you should understand my goals.

Being a side project, I always make sure that I am learning something new along the way. Chris has the same perspective, outside of "making a game" we both have these learning goals:

* To learn how to draw using Canvas element
* To learn more about "graphics" programming in JavaScript
* To learn more about making games and game development

Me, being a professional application developer, I also had the goal of:

* Learning to apply my application development skills to the game development world

This last goal is really important to me and is framed as a goal rather than a problem. Everything I understand about game development demonstrates that it's quite different from regular application development. In the past, I've gotten stuck thinking of a game like it's a regular application. Hopefully with this goal in mind, I'll be able to push through my tendency to build an app rather than a game.

## Why use a JavaScript Framework?

Let's start with the path I took for my project: to learn a new JavaScript framework.

### Pros

Let's start with the good stuff, shall we?

#### Simplification

A framework provides an abstraction over the native API's provided by JavaScript, which _should_ simplify things a little. For example, when it comes to drawing on a canvas, I create the objects that I want and give them to the engine, and voilà, they are drawn. I don't need to worry about the specifics on how it actually draws it, which allows me to focus on things like architecture and how to leverage the game loop itself.

#### Guidance

Being new to game development, the framework provides me guidance on how to build a game rather than a business application. This has helped me immensely, as it's forced me to use a game loop and a game object hierarchy, which has helped me learn how a game works differently than a regular JavaScript application.

#### Support Network &amp; Productivity

![network][4]

As with any popular framework, you're going to get other experts who have already implemented things with the framework. This way, I'm not re-inventing the wheel when it comes to finding a way to implement a feature. Rather, I can learn from what others have asked, done, and documented, and apply that to my game quickly, rather than having to come up with my own solution every time something comes up.

Plus, if there is an issue with one of the many functions of the framework, the community can rally behind it and push out a fix rather than just having myself to rely on for fixing any and all issues.

### Cons

Even with all that good, there are some shortcomings that I should note alongside the pros.

#### Framework Lifespan

![dead-framework][5]

In JavaScript, there are plenty of flavours of whatever framework you're using.

For every Phaser, there are at least another dozen frameworks that do the same thing, just in a different way. When it comes to picking one, there is a good chance that in a few years (or a few months in some cases) all my knowledge of the framework will be deprecated knowledge as the industry will have moved to the "next new thing", along with the support network I mentioned earlier.

#### Performance

I heard the term "Fast Food frameworks" for the first time from [Chris Love][6]. Now that I've gone with Phaser, my game now requires this framework to run, and its performance and compatibility with different platforms is dependent on the framework. So far, I have no issues, but as things get more complicated, I could find myself tightly coupled to the performance limitations of the framework, whatever they may be.

On top of that, even though I'm not using all of the parts of Phaser, I'll need to include the whole library, which can lead to slower load times, especially when we're talking about playing the game on the web.

## To Summarize

For my needs, a framework allows me to focus on learning the higher level concepts of game development while applying my existing JavaScript and application developments. The framework also keeps me within the game development paradigm by means of forcing me down a certain implementation path (i.e. using the Phaser game loop).

All that being said, there are still great reasons not to use a JavaScript framework. We'll cover that in part 2 of this series.

[1]: http://blog.davidwesst.com/2016/02/JavaScript-Framework-or-Pure-JavaScript-P1/js-framework-or-pure-js.png
[2]: https://github.com/davidwesst/finder-game
[3]: https://github.com/chrinkus/walk
[4]: http://blog.davidwesst.com/2016/02/JavaScript-Framework-or-Pure-JavaScript-P1/network.png
[5]: http://blog.davidwesst.com/2016/02/JavaScript-Framework-or-Pure-JavaScript-P1/dead-framework.png
[6]: http://love2dev.com/#!article/Large-JavaScript-Frameworks-Are-Like-Fast-Food-Restaurants
  
