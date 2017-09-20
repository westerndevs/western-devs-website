---
title: Windows Subsystem for Linux is Cool. No really, it is.
date: 2017-09-19 12:35:00 -600
categories: 
    - web
tags:
    - microsoft-edge
    - f12
    - linux
    - windows subsystem for linux
    - wsl
excerpt: "With the Fall Creators update of Windows 10, you can go to the Windows Store and install Linux. Yeah, that's a thing now and it's pretty cool."
---

[1]: https://summit.microsoftedge.com/
[2]: https://davidwesst.blob.core.windows.net/blog/websummit-wsl/ubuntu-install.gif
[3]: https://www.cygwin.com/
[4]: https://msdn.microsoft.com/en-us/commandline/wsl/install_guide
[5]: https://insider.windows.com/en-us/
[6]: https://blogs.msdn.microsoft.com/commandline/

_This is part of a series of posts capturing the highlights from my experience at the [Microsoft Edge Web Summit 2017][1]_

![Installing Ubuntu on Windows 10 from the Windows Store][2]

With the Fall Creators Update for Windows 10, you can go to the Windows Store and install Linux.

Yeah, that's a thing now and it's pretty cool.

## What is the Windows Subsystem for Linux (WSL)?
It's a new Windows feature that allows Linux distributions like Ubuntu and OpenSUSE to run inside of Windows. Essentially, this let's you run Linux-based command line applications against your files stored in Windows.

## Why is that cool?
It's cool because a lot of the web runs on Linux, but many of us develop on Windows because the business runs on the Windows platform. This means that the dev tools you have installed to run your build and test your application are the Windows versions.

It might not seem like a big deal, but it's definitely a discrepancy. How are you expected to catch Linux issues before you deploy if you're running Windows? The WSL, that's how.

## Isn't this just CygWin?
No, it's different.

According to the [CygWin homepage][3]

> Cygwin is:
> * a large collection of GNU and Open Source tools which provide functionality similar to a Linux distribution on Windows.
> * a DLL (cygwin1.dll) which provides substantial POSIX API functionality.

WSL, is a layer inside of Windows that allows actual Linux distributions to run against. Microsoft is providing the foundation for Linux distributions to build upon, and keeping their hands out of the tooling itself.

When you're using CygWin, you're not using a Linux distribution. You're using CygWin. With WSL, you're not using any Linux distributions unless you install them on top of the WSL. Once you do, you're using the tooling provided and build _for that Linux distribution_.

## Isn't this just Bash for Windows 10?
No, it's also different.

Although I won't get into the weeds with it, Bash for Windows 10 was something of a precursor to the Ubuntu distribution that is in the Windows Store. Think of it as an Ubuntu for Windows preview.

Now, we're not limited to just Bash on Ubuntu. We can install OpenSUSE and run bash on that, and eventually Fedora, and probably other flavours of Linux as time goes on. So you can run two different or three different versions of Linux against the Windows filesystem at the same time, without needing a bunch of VMs running. 

## Why don't I just run Linux?
You totally can, this doesn't change that.

This is a dev tool, first and foremost. It's meant to (IMHO) provide developers a easier way to run Linux tools on Windows, with the resource boundaries and extra resource consumption of a virutal machine.

For example, if you're running Apache on your Linux-based web server, you no longer have to run Windows-based Apache. Rather, you can install the Linux version of Apache on Ubunut or whatever, adn directly against your Windows filesystem. No VM to prep, or system boundaries to cross. Just install and run it.

## How do I start?
You can start by [installing the WSL on your Windows 10 machine][4]. 

The Windows Store animation I showed at the beginning of this post is using an [Insiders Build][5] of Fall Creators update for Windows 10. You can join the insiders program yourself learn about that [here][5].

Until the Fall Creators update, you can still start tinkering with Bash on Ubuntu for Windows 10 by following the [install instructions][4] provided earlier.

## Anything else?
Yeah. 

They are finally fixing the console window in Windows, so that's a thing too. Read about it on [the team's blog][6].

---

## Resources

* [Windows Command Line Tools Blog][6]
* [Installing WSL Instructions][4]