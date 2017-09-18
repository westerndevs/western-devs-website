---
title: Service Workers and PWAs are Super Cool
date: 2017-09-18 13:35:00 -600
categories: 
    - web
tags:
    - microsoft-edge
    - service-workers
    - progressive-web-apps
    - javascript
excerpt: "One of the core items highlighted by the Microsoft Edge team, along with many others who were just web professionals, was the importance of Progressive Web Apps (PWAs). I started out thinking they were something that could be interesting one day, but left the conference convinced that this will change the way we think of the web."
layout: post
authorId: david_wesst
---

[1]: https://summit.microsoftedge.com/
[2]: https://developers.google.com/web/progressive-web-apps/
[3]: https://davidwesst.blob.core.windows.net/blog/websummit-pwa/pwa-logo.svg
[4]: https://diekus.net/logo-pwinter/
[5]: https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API
[6]: https://developer.mozilla.org/en-US/docs/Web/API/Push_API
[7]: https://developer.mozilla.org/en-US/docs/Web/API/Payment_Request_API
[8]: https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API

_This is part of a series of posts capturing the highlights from my experience at the [Microsoft Edge Web Summit 2017][1]_

One of the core items highlighted by the Microsoft Edge team, along with many others who were just web professionals, was the importance of Progressive Web Apps (PWAs). I started out thinking they were something that _could_ be interesting one day, but left the conference convinced that this will change the way we think of the web.

## What is a PWA?
![PWA Logo from diekus.net/logo-pwinter][3]

[Google has been talking about PWAs][2] for a while now, but in my words they are web applications that use a progressive enhancement design strategy to add device native features, when available.

So, it's just a web app with some fancy bells and whistles, like offline loading once the site has been downloaded once and native device API access, like camera access or push notifications straight to the device.

If it sounds like regular installed application rather than a web application, then you're understanding this correctly.

PWAs _could_ be the next wave of "apps" for our devices, but they won't need a store front. Rather, the user can just navigate to the site and "install" the site, which can be cached for offline usage amongst other things.

## What makes them super cool?
Outside of the coolness of extending the reach of the web into offline world, it's also built on a set of open web standards.

Standards give developers APIs to use across platforms, but they also give the platform holders something common to build against. Both Windows and Android have big plans for PWAs, giving web developers a whole new opportunity to use our existing skills to deliver great software. 

Just to be clear, software that can be offline and installed natively, using web development tools and skills.

That _is_ super cool.

## So, where do I start?
With the [Service Worker API][5].

This is the first step in building a great PWA, as it allows you to "install" the web application on the device. Once you have it installed, then you can worry about the rest of the functionality and how it should work.

On top of that, start looking at some of the new APIs that have been coming out of the W3C like the [Push API][6], the [Payment Request API][7], and [IndexedDB][8].

This should give you a good idea of what can do with a PWA rather than a regular old web application. 


