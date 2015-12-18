---
layout: post
title:  "Adventures in Windows IoT Core for Raspberry Pi 2"
date: 2015-09-22T10:50:22-04:00
categories:
comments: true
authorId: darcy_lussier
originalurl: http://geekswithblogs.net/dlussier/archive/2015/09/20/166942.aspx
alias: /adventures-in-windows-iot-core-for-raspberry-pi-2/
---

Ever since I won a Raspberry Pi 2 at Microsoft Ignite I've been trying to figure out what to do with it. This week I decided to look at the Windows 10 IoT Core for Raspberry Pi 2 and see what I could do to get something up and running.

<!--more-->
  
I'm not going to re-hash how to set up the device or how to configure your development environment; there's already some great articles that cover this which I link to further below. But I will share some first impressions which may prep you for working with the platform.

Windows IoT Core (WIoTC) is, as their own website states, a work in progress; a very early work in progress. Compared to Raspian, which has a desktop-like GUI complete with windows, WIoTC seems very primitive. You're very limited in what information you can get (I couldn't get the MAC address of the Raspberry Pi 2 from the WIoTC interface) and the suggested way to manage your device seems to be through PowerShell via another PC on the same network.

Deployed apps can either be a Universal Windows App or Headless (background process). Only one UWA will be displayed at a time. There's no built in menu or anything, so don't think of this as a Windows Phone type of experience…its less than that. Users won't automatically have an "Installed Programs" list to refer to. Also, while you can deploy a Universal Windows App to the Pi, [there's a documented list of unavailable APIs that aren't part of WIoTC][1]. So you can't just assume what you write for Win 10 desktop or even the phone platform will transfer over easily.

WIoTC doesn't take full advantage of the hardware yet either. [Mike Dailly][2] posted [a Vine showing that GameMaker Studio games can run][3] on the platform, [but very slowly due to the GPU not being used at all (graphics are drawn using software emulation][4]).

This may sound very negative, but considering how new WIoTC is and that they likely targeting the base/required functionality for an initial release I think its pretty cool that using Visual Studio I can deploy an app to this mini-computer on my desk. There's great opportunity with WIoTC and I'm actually happy they didn't try to force a bloated platform out for v1; better to involve the community and develop things as needed instead of making assumptions.

Now that I've done my first Hello World app, its time to start looking at the next step of playing with my Raspberry Pi. Stay tuned!

#### Links
Microsoft Dev Center – IoT   
<https://dev.windows.com/en-us/iot>
This site is the best starting point for setting up your device, dev environment, doing your first project, and getting up to date information.

Michael Crump's Guided Tour of Windows 10 IoT Core   
<http://developer.telerik.com/featured/a-guided-tour-of-windows-10-iot-core/>
Great walkthrough by [Michael Crump][5] which also shows how to use one of the Telerik controls and links to related topics.

[1]: http://ms-iot.github.io/content/en-US/win10/UnavailableApis.htm
[2]: https://twitter.com/mdf200
[3]: https://vine.co/v/eDu3FF5Prdr
[4]: https://connect.microsoft.com/windowsembeddedIoT/Feedback/Details/1505683
[5]: https://twitter.com/mbcrump
