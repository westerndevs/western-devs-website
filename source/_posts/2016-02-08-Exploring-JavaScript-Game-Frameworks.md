---
layout: post
title: Exploring JavaScript Game Frameworks
categories:
    - JavaScript
    - Game
date: 2016-02-08 16:11:44
tags:
    - JavaScript
    - Game Development
excerpt: David reviews a handful of JavaScript-based game frameworks he went through before selecting one for his new game.
authorId: david_wesst
originalurl: http://www.webnotwar.ca/opensource/exploring-javascript-game-frameworks
---
Last month I explored a number of JavaScript-based game frameworks in an attempt to pick the perfect one for my first game.

I thought I'd take a moment to share four of them that really stood out to me, along with a few honerable mentions.

**Note** that I've left a bunch off the list, as that is the nature of a "top X" list. If I missed your favourite one, then feel free to let me know in the comments!

### Phaser
![](http://blog.davidwesst.com/2016/02/Exploring-JavaScript-Game-Frameworks/phaser.png)

I'll start with the one I picked for my game. [Phaser](http://phaser.io/), developed by Richard Davey (a.k.a. [@PhotonStorm](https://twitter.com/photonstorm)) is an open source JavaScript game framework for desktop and mobile games.

After going through [the Phaser tutorial from GameFromScratch.com](http://www.gamefromscratch.com/page/Adventures-in-Phaser-with-TypeScript-tutorial-series.aspx), here's what I liked about it:

* It's just a framework, plain and simple. No special IDE or engines needed, just code.
* It's [open source](https://github.com/photonstorm/phaser) and widely used, and has a strong community surrounding it
* It's stable, mature, and actively developed for a JavaScript framework. Currently at vervsion 2.4.4 at the time of writing, with [v3 in the works](http://phaser.io/labs).

What really drew me towards Phaser was it's well documented API, and the numerous tutorials and examples from the community. Even though I'm just starting out, every feature that I've looked to implement appears to have been at least partially implemented and documented in a tutorial, making the learning curve much less steep than it could have been.

You can check it out on [GitHub](https://github.com/photonstorm/phaser).

### Superpowers
![](http://blog.davidwesst.com/2016/02/Exploring-JavaScript-Game-Frameworks/superpowers.png)

I think [Superpowers](http://superpowers-html5.com/index.en.html) one has a lot of potential. Seeing the [game demo](http://sparklinlabs.itch.io/discover-superpowers) they made really gave me all the proof I needed believe in what they're doing over there at Sparklin Labs.

Here's the highlights that stood out to me:
* Totally [open source](https://github.com/superpowers/superpowers), as in the engine and the tooling
* Toolset is a browser-based IDE for game development
* Powered by [TypeScript](http://www.typescriptlang.org/), giving you the power of JavaScript with some extras

The only drawback I found was that it was really new when I was shopping for a game framework, which means that it's more on the bleeding edge than the cutting edge IMHO. Still, this is one I'll be watching.

If you're interested in learning how to leverage Superpowers, I suggest checking out their [documentation site](http://docs.superpowers-html5.com/en/getting-started/about-superpowers) or this [GameFromScratch.com tutorial series](http://www.gamefromscratch.com/post/2016/02/01/Superpowers-Tutorial-Series-Part-One-Getting-Started.aspx).

### PlayCanvas
![](http://blog.davidwesst.com/2016/02/Exploring-JavaScript-Game-Frameworks/playcanvas.png)

I discovered [PlayCanvas](https://playcanvas.com/) when I bought a Humble Bundle focused around game development tools. PlayCanvas seems to be cut from the same cloth as SuperPowers, but is a bit more mature considering it's been around longer. It focuses more on 3D content, although I'm sure you could do 2D content just fine.

Here's what made PlayCanvas interesting to me:
* Engine is [open source](https://github.com/playcanvas/engine), but tooling is not
* Tooling runs in-browser, making it accessible to any development platform
* Tooling was very easy to use, and I was able to start for free

PlayCanvas really reminded me the [Unity3D](https://unity3d.com/) toolset, which is widely used in the industry. Given, the value is really in the tooling, which isn't open source. Still, it might be worth checking out if you are looking for a toolset to go with your game engine.

Here's another [GameFromScratch tutorial](http://www.gamefromscratch.com/post/2015/04/19/A-Closer-Look-at-the-PlayCanvas-Game-Engine.aspx) that helped me get things moving.

### Haxe
![](http://blog.davidwesst.com/2016/02/Exploring-JavaScript-Game-Frameworks/haxe.png)

Okay, so [Haxe](http://haxe.org/) really isn't JavaScript, but it's very similar to it and supports web development, so I'm including it. Plus, it really did stand out as a viable option to me when picking my game for a few reasons:

* It's a language/toolkit that focuses on game / rich UI development
* Very mature and has plenty of support around it for whatever games you'd like to develop
* Is the cornerstone of the [Haxe Foundation](http://haxe.org/foundation/)
* When targetting JavaScript, you can leverage other JavaScript libraries

Haxe is something that I keep coming across in my adventures with game development, and one day I'll head back and learn more about it. Just need to find the right project, and feel a bit more comfortable with game development.

You can checkout the [source code here](https://github.com/HaxeFoundation/haxe) but I'd suggest exploring [the website](http://haxe.org/) for more information.

## Honorable Mentions
To close things out, I wanted to highlight a few other frameworks and toolsets that I thought were pretty cool but wasn't what I was looking for with my project.

* [BabylonJS](http://babylonjs.com/)
* [ThreeJS](http://threejs.org/)
* [PixiJS](http://www.pixijs.com/)

If I missed your favourite (which I'm sure I did) you should drop it in the comment section and share your favourite library and/or toolset. Extra points for open source repository links on the libraries.