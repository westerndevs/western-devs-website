---
title: Posh-GVM, the Groovy Version Manager for Powershell
date: 2017-08-17 10:00:00
category:
    - java
tags:
    - grails
    - groovy
    - gradle
    - powershell
    - version manager
excerpt: "Here's another dev thing I use: Posh-GVM, a Groovy version manager that works for Windows."
layout: post
authorId: david_wesst
---

[1]: https://davidwesst.blob.core.windows.net/blog/posh-gvm/poshgvm-example.gif "Posh-GVM in action in a Powershell terminal"
[2]: http://www.westerndevs.com/java/jabba/ "My post on Jabba, the Java version manager for everyone"

Here's another dev thing I use: [Posh-GVM](https://github.com/flofreud/posh-gvm), a Groovy version manager that works for Windows.

You remember Groovy right? The language that was all the rage at some point with Groovy on Grails?

All kidding aside, in my adventures as an enterprise JDK developer, I've come across a number of Groovy on Grails applications. These projects tend to span multiple versions of Grails, ranging from 2.3.x which works on older versions of Tomcat, upto 3.2.x for of of our newer solutions. Instead of manually configuring my system for each project, I just use Posh-GVM as recommended by the folks who brought you [SDKMan for Unix systems](http://sdkman.io/).

![Posh-GVM in action][1]

## What does it do?
It handles switching between versions of Groovy, Grails, and a bunch more technologies without having to fuss with configuring your system. It switch between versions of Grails, Groovy, Gradle, Koitlin, and more with `gvm use <candidate> <version>` where candidate is the technology and version is...well, the version.

## Using Posh-GVM
Posh-GVM is a Windows port to [SDKMan](http://sdkman.io/) formerly known as the GVM, or Groovy eVironment Manager. Instead of requiring a Unix system to run, it requires Powershell.

To install it, I followed the README instructions to install it via [a short script](https://github.com/flofreud/posh-gvm#via-short-script). I tried using the PsGet method described, but didn't have any luck finding the module. More on that later.

Once installed (and added to your profile) you can run `gvm help` in the Powershell terminal and you should see a lovely help menu with all the goodies you can install and switch your fingertips.

### Won't these conflict with the versions I already have installed?
No. It installs the tools in a different directory, so you should be good.

That being said, you probably don't need to have a local version of Grails or whatever tool installed anymore because Posh-GVM will handle that for you. 

## What makes it cool?
It's cool because it works on Windows, without the need for Bash or Cygwin.

The fact that it covers a number of tools, including Grails, Groovy, and Gradle (and many more) is a pretty nifty too. 

## What are the drawbacks?
There are two that stand out to me, but nothing that has made me abandon the tool for something else.

### Java not included
The first being that it doesn't support Java like it's Unix couterpart. My guess is that Java is something special when it comes to Unix VS Windows and was eliminated for that reason. We have [Jabba][2] for that on Windows, but it would be nice to have all the pieces in to the puzzle in a single tool.

### Lack of Project Activity
The second is the lack of updates.

As of this writing, it hasn't been updated since [December 2015](https://github.com/flofreud/posh-gvm/commit/2145f8a65c5bf317e96664ebb03bf84c569ba770) while SDKMan has continued to be actively developed.

This isn't necessarily a bad thing, as there haven't been any pull requests in quite some time either. It's just something I note as a risk when I adopt an open source tool.

---

Ultimately, I think this tool is a great solution for people that need to use any of these tools, but don't want to couple themselves to Cygwin or Bash for Windows. It has solved my Grails, Groovy, and Gradle versioning issues on Windows, and that is more than enough to make it a win in my books.