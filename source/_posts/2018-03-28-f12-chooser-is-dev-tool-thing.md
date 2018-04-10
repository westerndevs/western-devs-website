---
layout: post
title: "F12 Chooser is a Dev Tool Thing"
tags:
  - JavaScript
  - TypeScript
  - Web Extensions
  - Office Add-In
categories:
  - Development
authorId: david_wesst
date: 2018-03-28 13:10:00
---

The F12 Chooser is a development tool thing that I like. You should know about if you want your web application or web extension to support Microsoft Edge. 

<!-- more -->

[1]: https://i.imgur.com/wt4L09z.png
[2]: https://i.imgur.com/ch1TjEr.gif
[3]: https://docs.microsoft.com/en-us/office/dev/add-ins/testing/debug-add-ins-using-f12-developer-tools-on-windows-10
[4]: https://docs.microsoft.com/en-us/microsoft-edge/devtools-guide

![1]

The [F12 Developer Tools][4] are pretty great. They are the original in-browser developer tools (included in Internet Explorer 7), and have evolved into something more modern for all us "modern" developers.

With all in-browser developer tools, I've found that every once and I come across an application I'm trying to debug that is so unstable that F12 can't seem to attache properly. Whether that's because of the application locking up the browser or whatever, without being able to attach a debugger I can't really get into the code and start sorting out the issue.

That's where the F12 Chooser comes into play.

## What is F12 Chooser?
F12 Chooser is a utility built into Windows that allows you choose the target application for the F12 Developer Tools without having to open Microsoft Edge itself.

## How do I run it?
On Windows 10, you run `\\Windows\System32\F12\F12Chooser.exe`. The window that comes up will display a list of targets for which you can attach the F12 tools. You can find the 64-bit version in `C:\Windows\SysWOW64\F12\F12Chooser.exe`.

![2]

## Why does this matter?
Because it gives you another option when it seems like the F12 tools are failing. If your browser locks up when you try and debug your application code, you should try the F12 Chooser once the application has loaded in the browser.

It also allows you to target applications that aren't necessarily web applications that you view in a browser. For example, maybe you're looking to debug an [Office Add-In][3].

## Conclusion
In conclusion, you have the F12 Chooser as another way to load up and attach the F12 developer tools in Windows 10 to help you with debugging web applications, web extensions, and even other things like Office Add-Ins.

And now you know it exists. You're welcome.