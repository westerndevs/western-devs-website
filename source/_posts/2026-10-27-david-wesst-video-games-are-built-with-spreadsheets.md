---
layout: post
title: Video Games are Built with Spreadsheets
date: '2026-10-27T12:00:00'
updated: '2026-10-27T12:00:00'
authorId: david_wesst
tags:
  - game-design
  - gamedev
  - game-development
  - project-passenger
  - spreadsheets
categories:
  - game-design
excerpt: >-
  I knew that spreadsheets were the glue that kept software projects together,
  but never realized how they would be so much more critical in video game
  development projects.
description: >-
  I knew that spreadsheets were the glue that kept software projects together,
  but never realized how they would be so much more critical in video game
  development projects.
originalurl: 'https://david.wes.st/blog/video-games-are-built-with-spreadsheets/'
crosspostId: a078d5452015e8a70e2b697760c70dd02b139b2607681e160015a042183e1f78
sourceCommit: 9c04583e01660361168f1114ead86f97e602379f
sourceBuildId: local-8ecb7a96-352f-4660-91bf-ac31c7bb7197
---

{% raw %}
<img src="/images/david-wesst/2026-10-27-david-wesst-video-games-are-built-with-spreadsheets/974bbb04087cb0be-spreadsheets-banner.png" alt="A player-stats and energy-balance spreadsheet with an arrow pointing to the Passenger game prototype.">
<p>I knew that spreadsheets were the glue that kept software projects together, but never realized how they would be so much more critical in video game development projects.</p>
<p>The more time I spend making a video game, the more I have come to realize that video games start with spreadsheets. Not code. Not pictures. But spreadsheets.</p>
<p>Spreadsheets for funding. Spreadsheets for balancing. Spreadsheets for localization. Spreadsheets, spreadsheets, and more spreadsheets.</p>
<p>Working in enterprise software, I am all too familiar with spreadsheets for managing projects, organizing teams, and all sorts of business activities.</p>
<p>They are the glue or duct tape that hold the project together, in a lot of cases.</p>
<p>For video games, I keep finding myself and the various experts I learn from using spreadsheets <em>to build</em> the video game itself, not just organize the business activities around it.</p>
<p>I'm sure there are more examples than I know about, but in this post I want to share where spreadsheets seem to make sense as the default tool to use.</p>
<blockquote>
<p>If you have other examples, reach out to me on <a href="https://bsky.app/profile/david.wes.st">Bluesky</a>, <a href="https://ca.linkedin.com/in/davidwesst">LinkedIn</a>, or <a href="https://youtube.com/davidwesst">YouTube</a> and tell me how you use spreadsheets to make your video game. I am genuinely interested in learning where else they fit into the development process.</p>
</blockquote>
<h2>Text Localization</h2>
<p>I have only dabbled in this one so far, but as I experimented with various dialogue systems, I saw how any dialogue or text needs to fit into a spreadsheet at some point to be localized.</p>
<p>A spreadsheet is a table, plain and simple. Using it to store data and then mapping that data to other data just makes logical sense.</p>
<p>This is why when I look at tools to help me with dialogue or text in my game, I make sure that they support export to a spreadsheet-friendly format like CSV.</p>
<h2>Gameplay Models and Balancing</h2>
<p>This one is a little more involved. I heard <a href="https://jesseschell.com/">Jesse Schell</a> on a podcast talking about how he had used a spreadsheet to determine the balance of a trivia game he was making.</p>
<p>I figure if you can create a model to simulate trivia gameplay, you must be able to do it for other systems.</p>
<p>And so, with my current project <a href="https://cocobokostudios.com/#games">Passenger</a>, I have spent time modelling out how to crunch the numbers in a new part of the game I am trying to prototype.</p>
<p>After a few evenings of fiddling, I managed to get a spreadsheet that showed me how the formulas balanced out and what variables I had to adjust to make things easier or harder for the player.</p>
<p><img src="/images/david-wesst/2026-10-27-david-wesst-video-games-are-built-with-spreadsheets/243c2ea4620142b4-gameplay-model-screenshot.png" alt="Gameplay-model spreadsheet showing player stats and adjustable energy-balance constants, including base energy cost, task multipliers, and optional task chance."></p>
<p>Let me emphasize what this has done for my project-- before adding more content to my game, I <em>know</em> how the gameplay system will be balanced. I don't think I know; I <em>actually know</em> how it will be balanced.</p>
<p>That doesn't mean the work is actually done. I mean, I still have to make it fun and all that. But I have a formula that I can adjust to make things easier (or harder) depending on player feedback and the feeling I am going for in the scene.</p>
<h2>Understanding Your Audience</h2>
<p>In <a href="https://david.wes.st/blog/defining-video-game-scope-with-documentation/">my last devlog</a>, I talked about documentation helping me define scope for Passenger by doing a competitive analysis on games I thought seemed comparable to the vision I have for Passenger.</p>
<p>This is all done in spreadsheets.</p>
<p>With the competitive analysis, I pulled all the tags for the comparable games and started crunching the data to figure out what tags aligned with my vision and what tags appeared more frequently with the comparable games. The overlap between these two sets of tags gives me the features I should include in my game.</p>
<h3>Example</h3>
<p><img src="/images/david-wesst/2026-10-27-david-wesst-video-games-are-built-with-spreadsheets/57f245f9789402e8-tag-analysis-screenshot.png" alt="Competitive analysis spreadsheet comparing game tags, including Story Rich, Life Sim, and Dating Sim, by applicability to Passenger, reference count, and appearances."></p>
<p>For example, you can see that Dating Sim is one of the tags I was considering for the game-- however, after doing some analysis on the comparables, I can see that it doesn't show up nearly as much as I thought it would.</p>
<p>This means that in terms of prototyping priority, the dating sim mechanics have dropped pretty low on my development schedule.</p>
<p>This saves me the effort of trying to figure out if that even works, as the audience I am trying to reach with Passenger doesn't really care about dating sim mechanics as compared to other features.</p>
<h2>Conclusion</h2>
<p>Spreadsheets are the duct tape of software development in general-- but they appear to be more than that for video game development.</p>
<p>They provide more than just the glue for video games. They provide the interface for working with non-game developer types and allow you to prove out your game idea before you even start drawing it out.</p>

{% endraw %}
