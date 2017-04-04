---
title: Introducing My Game Project | March 2017 Devblog
tags:
  - conquest
  - typescript
  - vsts
  - phaser
categories:
  - devblog
date: 2017-04-03 06:00:00
updated: 2017-04-03 06:00:00
originalUrl: https://blog.davidwesst.com/2017/04/Conquest-March-2017-Devblog/
authorId: david_wesst
excerpt: This is the first of monthly status update posts on my video game project I call Conquest.
---

I've wanted to make a video game since I was very young. It got me into programming during my university career, and is something of a passion of mine now that I'm older and more of a seasoned developer.

I've toyed and tinkered with different game ideas and technologies through the years, but never really got anything done. At the beginning of this year, I started working on something I decided would be my first "real" game. I'm not sure what it is yet, but it's turning into something after three month of development and design in my spare time.

Today, I'm going to share a bit about it with you, the public, for the first time.

## Introducing "Conquest"
This game is something of a life long conquest for me, but that isn't where the name comes from. This game started out as one idea where conquest made a lot of sense, but has transformed in a few ways over the past month to something completely different. I've been rolling with it and I like where it's headed now, but the name is going to stay the same until I get something a little more locked down.

In the meantime, you can take a look the [first official screenshots](http://imgur.com/a/x7eGr):

![First screenshot of "conquest"](http://i.imgur.com/dqEGoFf.png)

It's not much to look at, but this is just the beginning.

The goal is to get the gameplay loop and core systems down, based on the bit of design I have in mind. I've been doing pitch sessions with my SO (significant other), who has helped keep me and the multitude of ideas in check. Graphics and polish will come later, but for now it's all about the gameplay.

But enough of that, let's get status update.

## Status Update
The point of these posts is to try and help me reflect on what I've done, what issues I've faced, and where I'm going from here. Think of it as a sort of sprint review. Although this is three months of effort, I have started planning month long iterations where each iteration will end with a devblog post.

For those wondering, I use Visual Studio Team Services for that planning, but I'll discuss that in future regularily scheduled blog posts.

### What I've Done
Over the past three months, I've done quite a bit, but I'll keep it brief with bullet points.

+ Development
    + Selected [Phaser](http://phaser.io/) as the base game framework
    + Implemented signals for game events, triggered through timers and through player interaction
    + Implemented in-game time
    + Implemented map metadata layer
    + Setup issue and bug tracking in [VSTS](http://phaser.io/)
    + Setup contiuous integration and deployment to Itch.io using VSTS
+ Design
    + Did a "pitch" to solidify game idea and core gameplay concepts
    + Setup a map design workflow using [Tiled](http://www.mapeditor.org/) map editor

The gist of it is that I've focused on figuring out what sort of game I want to make by focusing on the things I already know: the tech.

### What I've Faced
Plenty.

I'll be more specific in future posts, but most of everything I've faced over these past three months has been around discovery and learning how to do basic game development. By using TypeScript (with it's definition files) and Phaser as my foundation, I've been moving pretty quickly and learning something new every time I sit down to work on the game. 

The other challenge I've is figuring out where to draw the line between development and design. At this point, I feel like I know where the line is and actually know that there _is_ a line between them. The challenge is making sure that I make sure to keep progress happening in both streams. Development work is familiar to me compared to design and ultimately more of a comfort zone for me to fall back on.

The problem is that without design, I'm just building game technology without purpose. How do I know what systems to build if I don't know what kind of game I'd like to build?

I've gotten much better at this over the course of February and March, and intend on keeping that going in future iterations by making sure that the number of dev and design issues are balanced each month.

### Where I'm Going
For the next iteration, I'm going to try and add two more systems to the game: a dialogue system, and an objective/goal system. There are more I'd like to add, but those two are the most critical. With these two in place I think I would have all the systems I need to the first part of the game playable and in front of players.

For the design side, I have a vision in mind for the first playable part. To build it, I need to design my first "real" map, complete with metadata and a story that is told through interaction with the map. The other thing  will be to make sure that I use the _existing_ systems I've developed to tell the story through the map, rather that defining new systems.

In summary, the goals for the sprint are:

+ Development
    + Display scripted dialogue in-game
    + Include objective for the player to accomplish
+ Design
    + Map of first playable section that tells a story through interaction
    + Leverage the each of the existing systems in the map to aid in story telling

## Conclusion
This post is the first of many. They will be monthly, and have more specific content about progress.

For a first post, this is pretty light on the details. That's mainly because there aren't a lot of details to share just yet. For now, all I can say is that I plan on continuing to blog about both the technical and the design challenges that I face along the way. Hopefully, over the next few posts, I will have something for you to play.

Until next month.
