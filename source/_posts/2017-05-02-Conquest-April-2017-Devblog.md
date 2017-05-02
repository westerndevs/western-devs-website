---
layout: post
title: Conquest April 2017 Devblog
tags:
  - conquest
  - ink
  - vsts
  - itch.io
  - javascript
categories:
  - devblog
date: 2017-05-02 08:31:41
updated: 2017-05-02 08:31:41
authorId: david_wesst
originalurl: "https://blog.davidwesst.com/2017/05/Conquest-April-2017-Devblog/"
---

This is the April 2017 update for my video game project I call "Conquest".

<!-- more -->

This month, I have continued to make progress on my game project. The unexpected thing that happened was the fact that I decided to take a step back and do some research and development before continuing forward with the game idea I have in mind.

## Status Update

Here's the thing: my game project is too big. At least for now, it's too big, and I don't have enough experience and knowledge to be co
fortable taking this idea and turning it into a game.

It's my first original video game, after all, and if you watch or read game design resources like [Extra Credits](https://www.youtube.com/user/ExtraCreditz), you'll often hear that you should start small and move up from there.

So that's what I did. And I made [Breakout](https://github.com/davidwesst/breakout) by following [this MDN](https://developer.mozilla.org/en-US/docs/Games/Tutorials/2D_Breakout_game_pure_JavaScript) tutorial.

![](http://i.imgur.com/TnoJp0Gm.png)

I know that this isn't going to blow anyone's mind, but it's first game I've made with nothing but vanilla JavaScript and let me get familiar with the basics of JavaScript game development, without blindly relaying on a framework.

I intend on continuing with this breakout game for another month as I prepare for [Prairie Dev Con](http://prairiedevcon.com/) to add some polish, clean up the code, and maybe add a few gameplay elements that I worked on this month.

But now, onto the update.

### What I've Done

Like last time, I'll keep it short and in bullet points:

+ Development
    + Did an automated deployment to [Itch.io](https://itch.io/) using Powershell and VSTS
    + Experimented with the [Ink](http://www.inklestudios.com/ink/) dialogue system and found how to integrate into build
    + Taken a step back on Conquest, in lieu of more R&D through smaller games
    + Created [Breakout](https://github.com/davidwesst/breakout) with vanilla ES6 JavaScript, complete with a transpiler and SystemJS modules
        + Thanks [Chris](https://github.com/chrinkus/) for the suggestion and [Chris Love from Love2Dev](https://love2dev.com/) for providing constructive feedback regarding framework dependent developers.
    + Setup my Vim development environment to be extra cool. 
+ Design
    + Met with an _actual video game writer_ to talk about the best way to start including narrative and dialogue into a game
        + Thanks [R. Morgan Slade](http://www.rmorganslade.ca/) for taking the time and providing some really good feedback and insight
    + Started migrating some design elements from Conquest into Breakout

### What I've Faced

This month, the big thing I faced was the realization that my project is too big for me. It's not that I don't think I would finish it eventually. It's that I don't think I have the skills to make the game fun when I'm done with it.

I also realized that I am too dependent on frameworks when it comes to game development. It's not that I don't think frameworks have a place or that I'll eventually use one or more of them in my game. It's that I don't know what the framework brings to the table other than an abstraction in development.

There are plenty of game design tools with full UI's that remove the need to code everything from the ground up, but since I've opted to go the code-focused route because that's what I know best, I should probably know a bit more about the layers code before I start abstracting them away.

### Where I'm Going

May is going to be busy with Prarie Dev Con happening in June, but that won't stop me from working on Conquest. I should also document these discoveries I make a little more, so I'll be doing that through the blog.

That being said, my plan is to focus on polishing up Breakout by using some of the planned features for Conquest in Breakout. They might not work all that well in that game, but the goal of Breakout isn't to make it a hit, but to experiment with these systems I have planned for Conquest.

To summarize, here's the plan:

+ Refactor Breakout to have a cleaner code base (i.e. modules, objects, etc...)
+ Share my VSTS game development discoveries via my blog
+ Add some polish to Breakout to complete it
+ Prepare my demos for [Prairie Dev Con](http://prairiedevcon.com/) using Breakout as the demo project

## Conclusion

What I've concluded this month is that I need to make games that match my skills as software developer. For that reason, I'm going to focus on learning the guts of the JavaScript by improving my vanilla JS Breakout game.

All in all, this month has been quite the shift in direction. I went from making one big game, to making one small game that has nothing to do with the original. It's been challenging, but in a good way. Now I can move forward with developing these systems in smaller pieces, refine them, and eventually recombine them into my original game design.

See you next month.
