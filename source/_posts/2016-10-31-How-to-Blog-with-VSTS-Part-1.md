---
layout: post
title: How to Blog with VSTS (Part 1)
categories:
  - alm
date: 2016-10-31 08:43:31
tags:
  - visual studio team services
  - vsts
  - alm
  - hexo
excerpt: I wanted to understand how to use Visual Studio Team Services (VSTS) for a "real" project. Being a noob, I decided to move my blog to VSTS to understand how _any_ project can benefit from ALM practices using VSTS. In part 1 of 5, we get things setup.
authorId: david_wesst
originalurl: https://blog.davidwesst.com/2016/10/How-to-Blog-with-VSTS-Part-1/
---

_This is part 1 of 5 of my **How to Blog with VSTS** series. Links to the other parts will be added as they are made available._

+ [Part 1: Setup][1]
+ [Part 2: Code][2]
+ Part 3: Work
+ Part 4: Build
+ Part 5: Release

[1]: https://blog.davidwesst.com/2016/10/How-to-Blog-with-VSTS-Part-1/
[2]: https://blog.davidwesst.com/2016/11/How-to-Blog-with-VSTS-Part-2/
[3]: #
[4]: #
[5]: #

---

I've been tinkering with Visual Studio Team Services off and on since its public release, but never did anything really productive with it. Over the past couple of weeks, I finally bit the bullet and decided to move my most prevelant personal project into VSTS: this blog.

This post covers the setup, and more specifically what I use to produce my lovely blog. We'll get into the thick of it in [part 2][2].

### Woah. VSTS _just_ for a Blog?
I know. Let me address this first before we continue.

It's definitely overkill. But, it provided me with a great learning experience for VSTS and the application lifecycle management tools is provides. It also was something that I'll actually use on a regular basis, as you'll see if you get through the whole series of posts.

So, yes it's like using a grenade launcher to kill an ant. That being said, it definitely gets the job done.

## The Parts
Here's what I use in my blog project, and what you'll need if you're going to follow along.

### Hexo or another Static Site Generator
If you're not familiar with static site generators, they are great for developers looking to blog or create simple sites. I won't be going into the details on how to use one, but they all seem to provide a similar sort of experience.

All you do is add files, generally in [Markdown](https://daringfireball.net/projects/markdown/syntax), fill out the configuration file, and run the generate command. The generator then generates a series of static HTML files from your content and then you have the files you need to publish to a web server somewhere.

No server-side code, no database, just a bunch of files. Real simple.

I use [Hexo](https://hexo.io/) for my [blog](https://blog.davidwesst.com), and it is used for the [Western Devs](http://www.westerndevs.com) site. It works well, and makes scripting your build and deployment ([which we'll see later][3]) much easier.

If you don't like Hexo then take a [look here](https://www.staticgen.com/) for a bunch of static site generators based in a variety of languages.

### Visual Studio Team Services Account
Sign up for the free account [here](https://www.visualstudio.com/vsts-test/) and create a new team project. I used the _Agile_ process because I found it gave me the flexibility I wanted, and _Git_ for source control.

If you want more details about the project processes available, and the differences between them, take a look at [this link](https://www.visualstudio.com/en-us/docs/work/guidance/choose-process).

!["Create a New Project in VSTS"](http://i.imgur.com/CYlb9sNm.png)

### Web Host
Just like any website, you're going to need a place to host it. Lucky for us, we're only hosting static files which makes the options pretty open.

I'm using Windows Azure, which again is overkill considering it's just static files, but I like it. If you don't want to spend money, I have also used [GitHub Pages](https://pages.github.com/) which is free and works just as well for what we'll be doing.

The important part is having a place to host the files once they are generated. No more, no less.

### Web Browser
VSTS is browser-based, so get a your favourite modern browser, get it updated, and you're good to go.

### Code Editor
We're not going to be doing much code, but it'll come in handy later on. 

Personally, I jump between [Visual Studio Code](http://code.visualstudio.com/) and [Vim](http://www.vim.org/). I'm sure you have your favourite, and that'll do just fine for our purposes.

## You Forgot Visual Studio
No I didn't. I don't use Visual Studio, nor do we need it.

It's not that I don't like it, but it's too heavy for the amount of coding I actually do for my blog. VSTS provides us with a web-based user interface that does everything we need for managing the source code, builds, and so on. 

In conclusion, I don't use Visual Studio here because I don't need it. 

## And We're Ready
Armed with our toolbox of goodies and our project created, we're good to go on starting to blog with VSTS. [Next up][2], we'll starting with what is familiar and getting our code into VSTS. 
