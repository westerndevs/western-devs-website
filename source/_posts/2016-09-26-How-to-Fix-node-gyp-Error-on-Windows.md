---
layout: post
title: How to Fix node-gyp Error on Windows
categories:
  - JavaScript 
date: 2016-09-26 14:51:56
tags:
  - NodeJS
  - JavaScript
  - node-gyp
excerpt: Whenever I get a new machine, I pull down a new project using the `npm install command and get an error related to python and node-gyp. This post will remember the fix for this problem that I always forget.
authorId: david_wesst
originalurl: https://blog.davidwesst.com/2016/09/How-to-Fix-node-gyp-Errors-on-Windows/
---

I hit this problem once or twice a year and always seem to forget how easy it is to fix the problem. This blog post will ensure that not only I remember, but the entire Internet will remember the solution I use.

Here goes.

## The Problem

The problem is simple: You pull down a repository that uses NPM for package management onto your Windows machine, you type `npm install` and you get something like this:

```
npm ERR! Failed at the <package>@<version> install script 'node-gyp rebuild'
```

or

```
gyp ERR! stack Error: Can't find Python executable "python", you can set the PYTHON env variable.
```

This is because the project you're trying to build requires the [node-gyp](https://github.com/nodejs/node-gyp) package to build something natively on the platform. That package required Python 2.7 and a few other pieces too.

## The Solution

Simple problems sometimes get simple solutions.

Thanks to the node-gyp team, that is the case and they have documented it in the project [README](https://github.com/nodejs/node-gyp).

Using a _PowerShell_ CLI instance with administrative priviledges, and use the following code:

```bash
npm install --global --production windows-build-tools
```

And that's it.

There is a manual option as well, but I haven't needed to use it as the first option always works for me.

