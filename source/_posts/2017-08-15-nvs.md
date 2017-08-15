---
title: NVS, the Node Version Manger for Everyone
date: 2017-08-15 12:35:00
category:
    - javascript
tags:
    - javascript
    - node
    - powershell
    - nvs
    - version manager
excerpt: "Here's another dev thing I use: NVS, or the Node Version Switcher. It works on Windows and it's great."
authorId: david_wesst
layout: post
---

[1]: https://davidwesst.blob.core.windows.net/blog/nvs/nvs-menu.gif "NVS Consle Menu in Action"

Here's another dev thing I use: [NVS](https://github.com/jasongin/nvs), a cross-platform Node version manager that works for Windows.

It's no secret that I like JavaScript, which includes [Node](nodejs.org/). The history of Node releases has been fast, furious, and [somewhat turbulent](https://stackoverflow.com/questions/27309412/what-is-the-difference-between-node-js-and-io-js) which led to a lot of different versions of Node being released. Manually managing the version of Node in you development enviornment is painful, just like it is for Java. For the Linux and Unix people, there was [nvm](https://github.com/creationix/nvm) and [n](https://github.com/tj/n), but nothing really comparable for Windows.

Until NVS that is.

## What does it do?
The Node Version Switcher switches versions of Node in environment. So, if you need to jump from 4.8.4 to 6.11.1, no problem. Just a quick `nvs add 6.11.1` and `nvs use 6.11.1` and you're ready to go.

No downloading binaries. No changing environment variables.

## Using NVS
Although supported on [OSX and Linux](https://github.com/jasongin/nvs#mac-linux), I'm going to focus on Windows as that is the environment where I use it the most.

You have two different installtion options on Windows, the first being a traditional installer file that you can download from [the release page](https://github.com/jasongin/nvs/releases) for the project.

The second is using [Powershell](https://github.com/jasongin/nvs/blob/master/doc/SETUP.md#manual-setup---powershell) or the good old fashioned [command line](https://github.com/jasongin/nvs/blob/master/doc/SETUP.md#manual-setup---command-prompt), both of which are described on the [setup page](https://github.com/jasongin/nvs/blob/master/doc/SETUP.md) for the project.

NVS even supported Bash for Windows, which is pretty great for those Linux-y Windows people, although it requires a few manual configuration steps.

Once you get things installed, you can run `nvs` and go through the interactive menu goodness to get your favourite flavour of Node installed.

![NVS Interactive Console Menu][1]

I really dig this interactive command line menu, which was created by the NVS author for NVS, and eventually turned into it's own library called [console-menu](https://github.com/jasongin/console-menu). But that is post for another time.

### Won't this conflict with my installed version of Node?
Not from my experience.

When I started with NVS, I had a version of Node installed, but I ended up uninstalling just to simplify my development environment. I kept forgetting that I had a base installation of Node installed. This confusion would result in me running `node --version` only to get a conflicting version number than the one I would see in my Windows Application list, and get me triaging an issue that didn't exist.

Plus, NVS provides a feature to set a default version of using the `nvs link` command.

### What about the global packages I've installed?
In the case where you install a package globally using a certain version of Node, when you switch to a different version, you could face some problems. More specifically, around code features available in Node based on what version of Node you've installed, or around the nested dependencies that get installed as part of a package your project needs.

Not an issue, as NVS provides the `migrate` command to move packages, global or otherwise from one version of Node to another.

### But what about my weird, custom Node versions?
No issue, because you can point to whatever directory you want as source for Node binaries using the [aliasing capabilities](https://github.com/jasongin/nvs/blob/master/doc/ALIAS.md#aliasing-directories).

```
C:\Users\dw\src\_scratch
> node --version
v8.1.4

C:\Users\dw\src\_scratch
> nvs use chakracore/8.1.2
PATH -= $env:LOCALAPPDATA\nvs\chakracore\8.1.4\x64
PATH += $env:LOCALAPPDATA\nvs\chakracore\8.1.2\x64

C:\Users\dw\src\_scratch
> node --version
v8.1.2
```

## What makes it cool?
It's cross-platform, so that's pretty awesome. But, there's more stuff that I haven't touched on in this post.

For example, there is bundled integration with [Visual Studio Code](https://github.com/jasongin/nvs#vs-code-support) which is a huge cross-platform bonus for me. VS Code is my editor of choice, and considering that it too is cross-platform, this is pretty great.

Other coolness to note would be things like [aliasing](https://github.com/jasongin/nvs#aliases) and [automatic directory swtiching]()(https://github.com/jasongin/nvs#automatic-switching-per-directory). Not to mention that it supports [ChrakraCore](https://github.com/nodejs/node-chakracore), making it easy to turn it on for all your [Time Travel Debugging](https://github.com/nodejs/node-chakracore#time-travel-debugging) needs.

All of that is icing on a delicious dev tool cake.

## What are the drawbacks?
Honestly, I'm not sure. I haven't found any so far, so that counts for something.

---

At the end of the day NVS does the job, and it does the job well. Plus, it comes with a bunch of cool extras that can make your Node development experience even more smooth.
