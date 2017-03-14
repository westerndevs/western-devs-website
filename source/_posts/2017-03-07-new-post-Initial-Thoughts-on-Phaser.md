---
layout: post
title: Initial Thoughts on Using Phaser
categories:
  - javascript
  - typescript
date: 2017-03-07 06:00:00
updated: 2017-03-07 06:00:00
tags:
  - javascript
  - typescript
  - phaser
excerpt: As a side project, I started making another JavaScript-based video game and decided to go with Phaser as my framework of choice. Here are my initial thoughts about Phaser after using it on my project for the past two months.
authorId: david_wesst
originalurl: https://blog.davidwesst.com/2017/03/Intital-Thoughts-on-Using-Phaser/
---

I'm not a game dev, but have always wanted to make a video game. I've started and stopped so many project over the years, that I have seriously lost count.

With the new year and a fresh mind, I decided to take a stab at it again, this time focusing on just getting something done rather than getting something _done right_ as a sort of side project.

It's been about two months since I've started, and I have something basic working (although I'm not willing to share it yet) and I thought I would share my thoughts on Phaser, the framework I decided to use to help me build my game.

## Techincal Requirements
Before we talk about the framework, let's talk about the game itself as you'll need to know what I'm building to understand why I chose the framework.

Here's the technical rundown:

* 2D
* Top-Down Camera
* Tile-based graphics
* Using [Tiled](http://mapeditor.org) for maps
* Gamepad support for player input
* TypeScript support

If you think back to the old NES (Nintendo Entertainment System) and SNES (Super Nintendo Entertainment System) days, games like Final Fantasy, and the Legend of Zelda are good examples of the look of the game.

!["The Legend of Zelda for the NES"](http://i.imgur.com/0LLlYoxb.png)

### Where did you come up with these Requirements?
I decided to make a game that I wanted to play. That's really about it.

I have plenty of ideas floating around in my head, but I went with one that had a look and feel of what I like to play. 

### Why TypeScript Support?
Although I'm a JavaScript nut, if find that TypeScript combined with the right tooling (Visual Studio Code) helps you learn an API thorugh code completion. Plus, it's compiler helps catch errors along the way without losing the versatility that comes with JavaScript. Since I'm learning a whole new domain (i.e. game development) I wanted to focus more on the learning practices and patterns, rather than worrying about the syntax.

We'll get into more of this later.

### Wait! What about the Game Design?!
That is a whole other conversation and series of posts that I may share if I ever get this project done. For now, they don't really apply as we're sticking to the technical side of the project.

(Although if you're interested, ping me on [Twitter](https://twitter.com/davidwesst) to let me know)

## So, Why Phaser?
I did quite a bit of research on this before going with Phaser. The two biggest contenders being [BabylonJS](http://babylonjs.com/) and the [CreateJS Suite](http://www.createjs.com/).

At the end of the day, Phaser not only did everything I needed it to do, but it  has a very strong community of support through [HTML5GameDevs](http://html5gamedevs.com/), and it does everything I need it to do. Plus, I had already tinkered with it a bit so that definitely gave it some extra points during the selection project.

## The Highlights
Now that I'm beyond the "tinkering" phaser, and into building a full game, I think I can weigh-in on the pros and cons I've come across thus far. I'm not far enough along to talk about performance, but for my little game project it seems to be running smoothly without fail.

### Support is Amazing
As mentioned previously, the support from [HTML5GameDevs](http://html5gamedevs.com/) is great. The forums are active, and there is even a live chat for people that are registered.

I've only asked one question so far, and it was answered very quickly. The rest of the time, I search the forums for my question and 99/100 times I'll find an answer.

The [examples section](https://phaser.io/examples) of the Phaser website gives links great code snippets that help wrap your brain around how to do things with the framework.

Lastly, as they prepare Phaser v3, the community has taken on Phaser v2 and has continued to release patches to the framework.

### Focuses on 2D
I'm just starting to learn game development and, on top of that, I'm doing this in my spare time.

When I get stuck I don't know what I don't know, but I can generally find my way around questions and articles that discuss 2D games. Since Phaser focuses on 2D, it makes consuming the API much more familiar to me rather that navigating my way around 3D game API (i.e. BabylonJS) that bring a whole new vocabulary to the table that I have to learn.

### Phaser-CE is What You're Looking For
It appears that they fixed it on the website, but when I was starting on this project there was no mention of _Phaser-CE_ on the homepage, and so I thought version 2.6.2 was the latest and greatest.

It turns out, that was incorrect.

As you'll see [here on the Phaser site](https://phaser.io/download/stable), version 2.6.2 was the last officially supported release, while v2.7.x is the community edition that is supported by those fine community members I mentioned earlier. So, when you install your dependency with `npm install phaser` you are installing an old version of the framework. You want `npm install phaser-ce`.

The change was minimal, considering it's the same framework. It just took me for a loop as I only figured this out as I tried to submit a pull request, only to find out that I was using the wrong version of Phaser.

### JavaScript First, TypeScript Second
I wanted TypeScript support up front because I knew it would help me get into the Phaser APIs. Now that I'm becoming more familiar with everything, I feel as though I should have toughed it out and stuck with JavaScript and Babel. 

The TypeScript definition files are part of the library and are not available on through [`@types`](https://www.npmjs.com/package/@types/npm) on the NPM. From what I can gather, they are done by hand. This isn't a big deal considering they work fine, but it makes me question their accuracy, especially not being avaialble through `@types`.

## Conclusion
I don't regret choosing Phaser as it met all my short term goals and I'm still learning a lot about game development and Phaser (and it's community) is helping me with that.

Next time around, assuming Phaser v3 isn't done yet, I would proabably go with [BabylonJS](http://babylonjs.com/) as it gives you everything Phaser does, but adds some pretty powerful tooling and 3D support along with it, and has the TypeScript support I expect.

All in all, Phaser has been a great place to start with game development. I highly recommend it.










