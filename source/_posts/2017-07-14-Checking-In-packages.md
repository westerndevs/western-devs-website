---
layout: post
title: Checking in packages
tags:
  - nuget
  - npm
categories:
  - development fundamentals   
authorId: simon_timms
date: 2018-10-21 11:36:36
originalurl: https://blog.simontimms.com/2018/10/21/checking_in_packages/
---

If there is one thing that we developers are good at it is holy wars. Vi vs. Emacs, tabs vs. spaces, Python vs. R, the list goes on. I'm usually smart enough to not get involved in such low brow exchanges... haha, who am I kidding? (vi, spaces and R, BTW) Recently I've been tilting at the windmill that is checking in package files. I don't mean the files that tell what version of files to check in but the actual library files. 

<!--more-->

Package managers aren't anything new, we've had them for years, decades even if you consider CPAN which has been online for 23 years. The idea behind them is that they provide an easy mechanism to install dependencies into your project. At the same time you can avoid checking in a bunch of library files and instead run a package restore as one of the build steps. 

I've heard a couple of arguments against relying on package managers instead of checking in your libraries. 

1. What if the package manager goes away? How could you still reliably build the software years in the future?
2. What if the specific package being used goes away? It might be unpublished like what happened with [left-pad](https://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/)
3. What if a transitive dependency, that is one that is included because it is a dependency of some other package, is revved and the package author of the included dependency left the dependency requirement open?
4. It takes a long time to restore packages using a package manager, we can speed up builds by not running the package restore during the build.
5. Everything you need to build your solution should be checked into source control. 

Let's break each one of these down and see why they are wrong headed.

1. Package managers have been around for years and aren't going away anytime soon. Perl is hardly a well used language these days but CPAN survives still. Package managers will outlast the applications built using the language. 
2. This is a totally legitimate concern. Fortunately policies have changed at [npm](https://docs.npmjs.com/cli/unpublish) and [NuGet](https://docs.microsoft.com/en-us/nuget/policies/deleting-packages) to no longer allow removing packages after a brief window. 
3. I've seen this happen with some frequency. Again package managers have changed to ensure that we no longer have this problem. Npm has introduced a package-lock file with version 5 and finally fixed how it works with version 6. By checking in this file we can be assured that we get exactly the right version of packages restored in a build. NuGet is, well, [trying to catch up](https://github.com/NuGet/Home/wiki/Enable-repeatable-package-restore-using-lock-file) on package lock files. Paket, which uses NuGet files under the covers does have [proper support for lock files](https://fsprojects.github.io/Paket/lock-file.html). 
4. This is a legitimate concern as well. I'd say that greater than 50% of my build times are spend restoring packages. Some of that time is downloading packages and some of it is solving the dependency graph. [Dylan](https://westerndevs.com/bios/dylan_smith/) has recently been [experimenting with caching packages](https://github.com/Microsoft/hash-and-cache) based on a checksum of the lock file. This, as it turns out, is quite a bit faster than simply downloading individual files from the package repository. This approach has been used for a while by Circle CI.
5. The goal is to make sure that you can always build every piece of code you own. One solution is to check everything in, but where do you stop? Do you check in the compiler? The system libraries? The operating system? Instead of checking everything in and hoping that they continue to build why not just run builds every night? 

We've countered every one of the big points for checking in packages. Now let me tell you why you shouldn't check packages in. 

1. It bloats the size of your repository. It does take time to download a repository and filling it up with multiple copies of no longer used packages is not helpful. Git works in a way that even if you delete a file it still exists in the image which is distributed to everybody who pulls the repository.
![Heavy weight repositories](https://blog.simontimms.com/images/checking_in_packages/weight.jpeg)
2. It is really easy to upgrade a package and forget to check it in or otherwise get the package file out of sync with what's on disk. 
3. The whole reason we have package managers is to help us handle installing and reinstalling packages - we should try to trust in them. 
4. If there is concern that packages may stop being available or that package servers will be unavailable then we can stand up an internal package server. This is also beneficial for developer builds. 

For NuGet we have the added problem that the package directory is no longer local to the source control directory so you have to really go out of your way to check in the packages folder. 

Stop checking in packages, it is a ridiculous outdated practice which is introducing bugs and slowing down builds.