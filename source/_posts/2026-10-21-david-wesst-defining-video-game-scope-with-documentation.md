---
layout: post
title: Defining Video Game Scope With Documentation
date: '2026-10-21T12:00:00'
updated: '2026-10-21T12:00:00'
authorId: david_wesst
tags:
  - gamedev
  - project-passenger
  - devlog
  - video
categories:
  - gamedev
excerpt: "Every project needs an end, and that includes video games. But how do you decide what \"done\" means for your prototype, your vertical slice, or even your whole game? I might not know much about game development—but I have a lot of experience defining software scope. For my most recent iteration, I spent time out of the code editor and in a Markdown editor. I even used spreadsheets! *gasp* \U0001F61C"
description: >-
  Every project needs an end, and that includes video games. But how do you
  decide what "done" means for your prototype, your vertical slice, or even your
  whole game? I might not…
originalurl: 'https://david.wes.st/blog/defining-video-game-scope-with-documentation/'
crosspostId: f58d4fb451d284c4890774181e056e728e946201d5f3a3dfa4cb540627fcc18a
sourceCommit: 799da64b23d9b57550e142c697cea9bcd0116a87
sourceBuildId: local-6bc3acae-166b-40bd-a243-7c39244f789e
---

{% raw %}
<img src="/images/david-wesst/2026-10-21-david-wesst-defining-video-game-scope-with-documentation/d66f1d39a0962506-0012-devlog-thumbnail_UPDATED.png" alt="A man holding up both hands, with the text &quot;Defining Scope for Games&quot;.">
<p>Every project needs an end, and that includes video games. But how do you decide what "done" means for your prototype, your vertical slice, or even your whole game? I might not know much about game development—but I have a lot of experience defining software scope. For my most recent iteration, I spent time out of the code editor and in a Markdown editor. I even used spreadsheets! *gasp* 😜</p>
<p>As I went through this past two-week iteration, I spent the majority of my time trying to nail down the project scope. More specifically, trying to answer three questions:</p>
<ul>
<li>What is this game?</li>
<li>What are my project constraints?</li>
<li>Where is my audience?</li>
</ul>
<p>Although I am not experienced in game development, I have quite a bit of experience defining scope for non-gaming projects. I tried to map that experience to what I am trying to do with the Passenger prototype.</p>
<p>So, what do you do to define scope in software?</p>
<p>You write documentation, of course! Which is exactly what I did this iteration.</p>
<p>Here's what I worked on in terms of documentation.</p>
<h2>GDD (Game Design Document)</h2>
<p><img src="/images/david-wesst/2026-10-21-david-wesst-defining-video-game-scope-with-documentation/30a469c5fdf049b6-gdd.png" alt="Passenger's game design document, showing its genre, target audience, and game loop."></p>
<p>A GDD is sort of the obvious one. I am not going to go into depth here about how to write one, as much more experienced folks out there have already done that. However, if you are unfamiliar with them, I suggest doing some research.</p>
<p>I based mine on the one shared at <a href="https://develop.games/">develop.games</a>, which is still available as a <a href="https://docs.google.com/document/d/1Vl7BMvzUOhbunJrI_X1gUc6x-LAp3aaBiPwHUf27B70/">Google Doc here</a>.</p>
<p>The GDD provides the scaffold for the project and, more importantly, a reference you can always return to when figuring out if something belongs in your game or if it's scope creep.</p>
<h2>Project Plan / Schedule</h2>
<p><img src="/images/david-wesst/2026-10-21-david-wesst-defining-video-game-scope-with-documentation/3b94a8910a8c6b1f-issue-backlog.png" alt="Passenger's project issue backlog."></p>
<p>I have grouped these together because they help define <em>the constraints</em> for the project.</p>
<p>With projects, you always have constraints. The usual suspects are time and money. In my case, I am most curious about time (mainly because I have very little to no money for the project at this point).</p>
<p>I use GitHub for the project plan, and it helps me understand how much work I need to do to complete the various milestones of the project. The schedule shows me how much time I have available and what beats I want to hit with my game. Together, these let you do "project math" to determine if you have enough time in your schedule based on how long you estimate the project will take.</p>
<p>Again, not going to elaborate on project math—and estimates, by definition, are not facts or truth. However, they can help you determine if you have too much scope in your plan and need to trim things down a bit.</p>
<p>You trim them down by reviewing the GDD and the issues list in your project plan to figure out if every feature is needed.</p>
<h2>Competitive Analysis</h2>
<p><img src="/images/david-wesst/2026-10-21-david-wesst-defining-video-game-scope-with-documentation/2456d8c6a86a6c96-competitive-analysis.png" alt="Passenger's competitive analysis spreadsheet."></p>
<p>I learned to put together a competitive analysis for a game through a masterclass and through local resources with the business development group <a href="https://newmediamanitoba.com/">New Media Manitoba</a>.</p>
<p>When you learn about what it takes to get funding for a video game, you find that it takes more than just a great pitch and a demo. It also takes a business plan.</p>
<p>The competitive analysis is what publishers and investors are going to want to see (amongst other things) to determine if your game is commercially viable, because it helps answer the question of <em>finding your audience</em>.</p>
<p>Once you know where your audience is (i.e. they are on the Steam pages of those comparable games), you can analyze the tags and figure out if your game idea aligns with the games you defined as comparable.</p>
<p>In my case, I assessed the tags that I wanted to use for my game and figured out if they aligned, in some capacity, with the games I believed to be comparable to Passenger. From there, I can start to deduce if my scope is big enough, too big, or too small for that audience.</p>
<p>It helped me answer the question <em>where is my audience?</em> when it comes to Steam. I can see the size of other games I believe to be comparable and figure out if my scope is realistic, too big, or too small.</p>
<h2>Story Outline</h2>
<p>This might not work for every game project, but it works for the ones with a narrative as a core feature of the game.</p>
<p>I started writing down the story to figure out how I would tell it through the gameplay mechanics I had defined so far and those I had planned. This exercise of understanding all my story beats helped me clarify the game I have in my head and, ultimately, whether I have all the pieces to deliver that story.</p>
<p>If I do, then my scope is probably in a reasonable state to deliver the vision I have in my head.</p>
<p>If I don't, then I either need to change my story or add the features I think I need.</p>
<h2>Related Devlog</h2>
<p>I recorded and published a video on <a href="https://youtu.be/EAB4uFQN6LE">YouTube</a>. I go into a bit more depth about some of these documents if you want more specific context about how I use them for Passenger.</p>
<p>Have a great rest of your day.</p>

{% endraw %}
