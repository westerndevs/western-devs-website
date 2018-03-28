---
layout: post
title: Environment Agnostic Packaging - Just Do It
tags:
  - devops
  - builds
categories:
  - Development 
authorId: simon_timms
date: 2018-03-26 14:38:30 
---

I've been noticing a bit of a trend lately around how some tools suggest you package your builds: they build differently for each environment. This is super-inconvenient if you're trying to progress a package through multiple environments. Just don't package configuration in with your build packages. 

<!-- more -->

Okay, let's break this down: when we build software as part of a release process on a CI server we end up with a package at the end. In modern devops, or what I would have called 'release engineering' back in the day, we then take this package and run it through the rest of the pipeline. The rest of the pipeline may consist of deploying to a test server, running integration tests, running UI tests, and promoting to higher environments. You can think the pipeline extending all the way out to the end user. The rule of thumb is that it is cheaper to catch errors and problems earlier in the build pipeline than later. That makes a lot of sense: a unit test catching a problem has an impact only on that developer while a user discovering a problem involves all sorts of layers of technical support and issue tracking, not to mention the cost of redeploying. 
<style>
@keyframes slidein {
  from {
    left: 0%;
  }

  to {
    left: 620px;
  }
}
.block{
width: 50px; 
height: 50px; 
  background-color: #39d; 
  animation-duration: 12s;
  animation-name: slidein;
  animation-iteration-count: infinite;
  animation-timing-function: linear;
  display: inline-block;
  position: absolute;
}
</style>
<div style="width: 100%; border-bottom: 3px black solid; height: 50px">
<div style="animation-delay: 0s;" class="block"></div>
<div style="animation-delay: -8s;" class="block"></div>
<div style="animation-delay: -4s;" class="block"></div>
</div>

One of the key features of the build pipeline is that the package which is released to production is the same package which has gone through the pipeline. If the package is different then what is the point of all the testing done in the pipeline? 

That questions was rhetorical but let me answer it anyway: There is no point, it is a waste and it wrecks the quality of your software. This is why I'm so surprised to see a number of really popular software packages which suggest compiling environment information into the package. This means that it no longer possible to deploy the package to testing environments or to environments not envisioned at build time. 

The two packages I've encountered recently which commit this sin are Angular 2/4/5 and the Serverless framework. Angular's build packages everything up using the [environment](https://blog.angulartraining.com/how-to-manage-different-environments-with-angular-cli-883c26e99d15) selected at build time and Serverless uses [stages](https://serverless.com/framework/docs/providers/aws/guide/variables/) which are basically the same thing. 

Now some people will claim that just rebuilding the same source code for each environment isn't a big deal: it will result it the same executable. Except that there are tons of times when it won't. `#ifdefs` can exercise different code paths, optimization levels on the compiler can produce different output, any one of a hundred other things could be different. The only way to be sure the package progressing through environments is correct is to ensure that it is, indeed, the same package. 

If you're a developer choosing frameworks I implore you to consider the full lifecycle of your package as it travels down the pipeline. Just pick a framework which supports sane devops practices. Just do it.  