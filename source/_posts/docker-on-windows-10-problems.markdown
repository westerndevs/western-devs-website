---
layout: post
title: "Docker on Windows 10 Problems"
date: 2015-08-10 09:20:40
categories:
comments: true
authorId: david_wesst
originalurl: http://blog.davidwesst.com/2015/08/Docker-on-Windows-10-Problems/
---

## UPDATE -- Solution Found
Another Western Dev that goes by the name of Dave White found a solution and I confirmed that it works. The solution entails using a test build of the new Docker tool suite, so use at your own risk, but it does work!

You can find the solution from Dave White [here](http://www.westerndevs.com/getting-docker-running-on-windows-10/), and learn more about the man himself [here](http://www.westerndevs.com/bios/dave_white/).

---
![](http://blog.davidwesst.com/2015/08/Docker-on-Windows-10-Problems/docker-logo.png)

I've hit some issues getting docker running on Windows 10. Turns out it's an issue with VirtualBox and it's being worked on, but I figured I'd share the details here just in case you're having the same issue.

You get the full scoop [here on GitHub](https://github.com/boot2docker/boot2docker/issues/1015) and [here on the Virtualbox ticket site](https://www.virtualbox.org/ticket/14040).

For those too busy to read the links, here's the executive summary.

### The Symptoms
You install [boot2docker](http://boot2docker.io) on a Windows 10 machine, and you can't seem to run the intro command `docker run hello-world` as instructed by the installer.

When you run `boot2docker init -v` you get an error `Failed to create host-only network interface`.

You have VirtualBox 5.0.x installed and Docker gives you problems like those described above.

### The Solution
So far there isn't an official fix, but there is [test build](https://github.com/boot2docker/boot2docker/issues/1015#issuecomment-127313908) as described on the boot2docker issue linked above. Personally, I haven't given it a shot, but it looks like things are on their way to be mended.

Here's hoping that it gets fixed so I can finally upgrade my desktop to Windows 10, and get docker running on my laptop.

*Thanks for Playing. ~ DW*
