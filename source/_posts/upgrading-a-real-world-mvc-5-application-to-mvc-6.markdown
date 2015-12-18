---
layout: post
title:  Upgrading a Real-World MVC 5 Application to MVC 6
date: 2015-07-23T12:08:42-04:00
categories:
comments: true
authorId: james_chambers
originalurl: http://jameschambers.com/2015/07/upgrading-a-real-world-mvc-5-application-to-mvc-6/
---

These are exciting times for web development on the Microsoft stack, but perhaps a little confusing as well. For many years the cycle of moving from one solution and project system to the next hasn't been overly complex. Sure, there have been breaking changes, I've felt those pains myself, but provided the framework you were using continued to live on, there was a reasonable migration path.

<!--more-->

Moving to MVC 6 is going to be a big shift for a lot of development teams, but that doesn't mean it needs to be scary, complicated or introduce instability into your project.

It does, however, mean that you're going to need an attitude of learning, that you'll pick up some new tooling, you'll have to brush up on your JavaScript and work with some new concepts.

## Let's Make it Happen

I'm super excited to now be part of the excellent crew at [Clear Measure][1], where this type of attitude seems to be fostered, encouraged and embodied by other members of the team and, more importantly, the management.

We're now undertaking the process of converting from MVC5 => MVC6 with our [Bootcamp workshop project][2] and I have the privilege of blogging my experience with it as I go. <img style="margin: 5px 0px 10px 10px; float: right; display: inline; background-image: none;" title="image" src="http://jameschambers.com/wp-content/uploads/2015/07/image_thumb2.png" alt="image" width="244" height="173" align="right" border="0" scale="0" />We're going to keep the project building and operable as we go, such that at an point it can be shipped to production or branched for feature development.  We'll be using GitFlow, feature branches, continuous integration and continuous deployment.  Our check-ins will be code that builds cleanly with passing tests.

**And,** for those of you who come join in our our MVC Masters Bootcamp sessions, you'll also get to work on this code base with all the tools, exposure to pair programming, a dedicated product owner and 3 days of intense coding.

<blockquote><a href="http://clear-measure.com/" onclick="_gaq.push(['_trackEvent', 'outbound-article', 'http://clear-measure.com/', '']);" target="_blank"><img style="margin: 14px 9px 7px 0px; border: 0px currentcolor; float: left; display: inline; background-image: none;" title="image" src="http://jameschambers.com/wp-content/uploads/2015/07/image8.png" alt="image" width="40" height="39" align="left" border="0" scale="0"></a><strong>Shameless plug</strong>: If you want to level up your team of developers, please reach out to <a href="mailto:gina@clear-measure.com??Subject=MVC%20Masters%20Bootcamp" target="_blank">Gina Hollis</a> at Clear Measure to plan an on- or off-site event. We promise to melt your minds.</blockquote>

## How We're Getting There

<img style="margin: 5px 0px 10px 10px; float: right; display: inline; background-image: none;" title="image" src="http://jameschambers.com/wp-content/uploads/2015/07/image_thumb3.png" alt="image" width="244" height="188" align="right" border="0" scale="0" />Well, to start it off, we're beginning with our initial commit as the MVC 5 project [Jeffrey Palermo's][7] been using in the Masters Bootcamp for some time.

The application is hosted on [GitHub][2] and you can [see the issues][8] that we're identifying and working through. We're doing the whole thing as open source in hopes that other teams can learn from what we learn in the process.

And, as I knock items off the issue list I'll be posting about them here, covering the challenges, pitfalls and wins we encounter along the way. You can bookmark this post for updates in the project. Feel free to ask questions on the issues in the repository, or ping me on Twitter ([@CanadianJames][9]).

Stay tuned!

[1]: http://clear-measure.com/
[2]: https://github.com/ClearMeasureLabs/ClearMeasureBootcamp
[3]: http://jameschambers.com/wp-content/uploads/2015/07/image_thumb2.png "image"
[4]: http://jameschambers.com/wp-content/uploads/2015/07/image8.png "image"
[5]: mailto:gina@clear-measure.com??Subject=MVC%20Masters%20Bootcamp
[6]: http://jameschambers.com/wp-content/uploads/2015/07/image_thumb3.png "image"
[7]: https://twitter.com/jeffreypalermo
[8]: https://github.com/ClearMeasureLabs/ClearMeasureBootcamp/issues
[9]: https://twitter.com/CanadianJames/
  