---
layout: post
title:  Outside the shack, or "How to be a technology gigolo"
date: 2015-07-05T21:11:15-04:00
categories:
description: The world outside is just awesome.
comments: true
author: kyle_baley
originalurl: http://kyle.baley.org/2015/07/outside-the-shack-or-how-to-be-a-gigolo/
---

Almost [four years ago](http://kyle.baley.org/2011/11/staying-home-for-the-night/), I waxed hillbilly on how nice it was to stick with what you knew, at least for side projects. At the time, my main project was Java and my side projects were .NET. Now, my main project is .NET and for whatever reason, I thought it would be nice to take on a side project.

The side project is [Western Devs](http://www.westerndevs.com), a fairly tight-knit community of developers of similar temperament but only vaguely similar backgrounds. It's a fun group to hang out with online and in person and at one point, someone thought "Wouldn't it be nice to build ourselves a website and have Kyle manage it while we lob increasingly ridiculous feature requests at him from afar?"

Alas, I suffer from an unfortunate condition I inherited from my grandfather on my mother's side called "Good Idea At The Time Syndrome" wherein one sees a community in need and charges in to make things right and damn the consequences on your social life because dammit, these people need help! The disease is common among condo association members and school bus drivers. Regardless, I liked the idea and we're currently trying to pull it off.

The first question: what do we build it in? WordPress was an option we came up with early so we could throw it away as fast as possible. Despite some dabbling, we're all more or less entrenched in .NET so an obvious choice was one of the numerous blog engines in that space. Personally, I'd consider [Miniblog](https://github.com/madskristensen/miniblog) only because of its author.

Then someone suggested Jekyll hosted on GitHub pages due to its simplicity. This wasn't a word I usually assocated with hosting a blog, especially one in .NET, so I decided to give it a shot.

Cut to about a month later, and the stack consists of:

* Jekyll
* GitHub Pages
* Markdown
* SASS
* Slim
* Rake
* Travis
* Octopress
* [Minimal Mistakes Jekyll theme](https://github.com/mmistakes/minimal-mistakes)

Of these, the one and only technology I had any experience with was Rake, which I used to automate UI tests at [BookedIN](http://www.getbookedin.com). The rest, including Markdown, were foreign to me.

And Lord Tunderin' Jayzus I can not believe how quickly stuff came together. With GitHub Pages and Jekyll, infrastructure is all but non-existent. Octopress means no database, just file copying. Markdown, Slim and SASS have allowed me to scan and edit content files easier than with plain HTML and CSS. The Minimal Mistakes theme added so much built-in polish that I'm still finding new features in it today.

The most recent addition, and the one the prompted this post, was Travis. I'm a TeamCity guy and have been for years. I managed the [TeamCity server](http://teamcity.codebetter.com) for CodeBetter for many moons and on a recent project, had 6 agents running a suite of UI tests in parallel. So when I finally got fed up enough with our deploy process (one can type `git pull origin source && rake site:publish` only so many times), TeamCity was the [first hammer](http://brendan.enrick.com/image.axd?picture=Golden-Hammer_1.png)<sup>*</sup> I reached for.

One thing to note: I've been doing all my development so far on a MacBook. My TeamCity server is on Windows. I've done Rake and Ruby stuff on the CI server before without too much trouble but I still cringe inwardly whenever I have to set up builds involving technology where the readme says "Technically, it works on Windows". As it is, I have an older version of Ruby on the server that is still required for another project and on Windows, Jekyll requires Python but not the latest version, and I need to install a later version of DevKit, etc, etc, and so on and so forth.

A couple of hours later, I had a build created and running with no infrastructure errors. Except that it hung somewhere. No indication why in the build logs and at that moment, my 5-year-old said, "Dad, let's play hockey" which sounded less frustrating than having to set up a local Windows environment to debug this problem.

After a rousing game where I schooled the kid 34-0, I left him with his mother to deal with the tears and I sat down to tackle the CI build again. At this point, it occurred to me I could try something non-Windows-based. That's where [Travis](http://travis-ci.org) came in (on a suggestion from [Dave Paquette](http://localhost:4000/bios/dave_paquette/) who I also want to say is the one that suggested Jekyll but I might be wrong).

Fifteen minutes. That's how long it took to get my first (admittedly failing) build to run. It was frighteningly easy. I just had to hand over complete access to my GitHub repo, add a config file, and it virtually did the rest for me.

Twenty minutes later, I had my first passing build which only built the website. Less than an hour later and our dream of continuous deployment is done. No mucking with gems, no installing frameworks over RDP. I updated a grand total of four files: .travis.yml, _config.yml, Gemfile, and rakefile. And now, whenever someone checks into the `source` branch, I am officially out of the loop. I had to do virtually nothing on the CI server itself, including setting up the Slack notifications.

This is a long-winded contradiction of my post of four years ago where my uncertainty with Java drove me to the comfort of .NET. And to keep perspective, this isn't exactly a mission critical, LOB application. All the same, for someone with 15-odd years of .NET experience under his obi, I'd be lying if I said I wasn't amazed at how quickly one can put together a functional website for multiple authors with non-Microsoft technology you barely have passing knowledge of.

To be clear, I'm fully aware of what people say about these things. I know Ruby is a fun language and I feel good about myself whenever I do anything substantial with it. And I know Markdown is all the rage with the kids these days. It's not really one technology on its own that made me approach epiphaniness. It's the way all the tools and libraries intermingle so well. Which has this optimistic hillbilly feeling like his personal life and professional life are starting to mirror each other.

Is there a lesson in here for others? I hope so as it would justify me typing all this out and <s>clicking publish</s> committing to the repository. But mostly, like everything else, I'm just happy to be here. As I've always said, if you've learned anything, that's your fault, not mine.

Kyle the Coalescent

<sub><sup>* With credit to Brendan Enrick's and Steve Smith's [Software Craftsmanship Calendar 2016](http://brendan.enrick.com/post/Making-The-Software-Craftsmanship-Calendar-Images)</sup></sub>
