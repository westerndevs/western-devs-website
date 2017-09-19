---
title: Sonar, the Linter I Never Knew I Wanted
date: 2017-09-19 12:35:00 -600
categories: 
    - web
tags:
    - microsoft-edge
    - sonar
    - accessibility
    - devops
excerpt: "Meet Nellie the Narwhal, the official mascot for Sonar, the linting tool for the web. Nellie represents a tool that is long-overdue. It provides any web application the ability to verify they are meeting a high level of quality when it comes to their web applications, and not miss any common mistakes."
layout: post
authorId: david_wesst
---

[1]: https://summit.microsoftedge.com/
[2]: https://davidwesst.blob.core.windows.net/blog/websummit-sonar/sonar-bttf.png
[3]: https://sonarwhal.com/
[4]: http://www.westerndevs.com/web/websummit-pwa/
[5]: https://davidwesst.blob.core.windows.net/blog/websummit-sonar/sonar-in-action.gif

_This is part of a series of posts capturing the highlights from my experience at the [Microsoft Edge Web Summit 2017][1]_

![Nellie the Narwhal in the Back to the Future DeLorean][2]

Meet Nellie the Narwhal. Nellie is the official mascot for [Sonar][3], the linting tool for the web. Nellie represents a tool that is long-overdue. It provides any web application the ability to verify they are meeting a high level of quality when it comes to their web applications, and catch any improvements to implement or common pitfalls to fix.

## What is Sonar?
Sonar is a linting tool for the web. Plain and simple.

It provides command line linting tool, along with some rules, that prevent developers from making some common mistakes or pitfalls with their web applications. It covers things like security, accessbility, and progressive web applications, to name a few.

You can also create your own rules for the linter, allowing you to extend the tool to check your solutions for business specific requirements.

Oh, and it's been [donated to the JS Foundation](https://js.foundation/announcements/2017/06/22/sonar-js-foundation-welcomes-newest-project), where Microsoft continues to contribute to it.

## Why do you want this?
Because of devops, that's why.

This is a command line tool that can break a build if your site doesn't meet specific requirements. Personally, I'm happy about the security and accessiblity rules they provide, but being that [I'm pretty focused on PWAs][4], I'm sure that Sonar is going to help me write better PWAs than I would have done learning on my own.

Personally, I'm looking forward to breaking a build because I forgot to implement some accessibility rules. It will help me and my team learn some of these optimizations to make our web projects work best for everyone on any device.

## How can I start using it?
![Sonar running against WesternDevs.com showing lots of issues][5]

It's pretty easy: just install, initialize, and run it.

As you can see, there is work for us to do if we want to bring our blog up to the recommended specification provided by Sonar. 

If you're looking to set a bar of quality, whether it be the recommended standard or just your own set of standards, Sonar is the tool that can make that happen.

---

## Resources
* [Sonar](https://sonarwhal.com/)
* [JS Foundation](https://js.foundation/)

## Image Credit
* [Nellie's Photo Album | Back to the Future](https://github.com/sonarwhal/nellie)