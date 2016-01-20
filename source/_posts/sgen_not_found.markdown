---
layout: post
title:  Task could not find sgen.exe using SdkToolPath
date: 2015-09-17T16:20:00-06:00
categories:
comments: true
authorId: donald_belcham
---

I spent the better part of this afternoon fighting with this error (and arguing Canadian voting rights with the [Western Devs](http://www.westerndevs.com)). I was trying to run our project’s build script which uses nAnt and MSBuild to work all the compilation magic we need. There are a lot of pieces of information on how to solve this on the web. Most solutions revolve around _"Install Visual Studio 2010"_, _"Install the Windows Software Development Kit for Windows X"_, or _"Turn off the generation of serialization assemblies in your projects/solution"_. Some of these are just downright scary solutions…others won’t work in my situation.

<!--more-->
  
I do almost all of my development work in Azure VMs these days. I can spin up a new one with Visual Studio already installed in minutes. This allows me to easily and quickly keep all of my different clients and projects in isolated buckets. So for one of my current projects I created a Windows 2012 R2 + Visual Studio 2015 VM. This is the VM that started throwing the above error. So when I asked the all knowing Google (and its smarter friend StackOverflow) I was perplexed by those three common solutions that I was finding.

* **Install Visual Studio 2010** – ummmm….no. Why should I need to do that? 
* **Install the Windows SDK** – there really isn’t one for Windows 2012. 
* **Turn of generation of serialization assemblies** – I have no idea if this project needs them or not so I’m not willing to make that change

This left me to piece together a solution on my own…which is likely why it took all afternoon. After looking through all the information that was buried in comments on answers for issues on StackOverflow, I managed to come up with this:

Open up regedit on your computer. You’re not going to change anything so just calm down. Navigate to **Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\4.0**

![Step 1](http://farm6.staticflickr.com/5618/21309498739_f91817e2d6_z.jpg)

Note the **SDK40ToolsPath** entry and the value for it. This value will point to another registry key which you need to go find next. It’s likely going to point at something that starts with **Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SDKs\Windows\**

![Step 2](http://farm6.staticflickr.com/5727/21309498889_112153e5f6_z.jpg)

As you can see here there’s an InstallationFolder key that has a file path for you to go find in Windows Explorer.

![Step 3](http://farm1.staticflickr.com/757/21308591438_fbc2579c84_z.jpg)

When you get to that folder you’ll probably see what I saw above…no sgen.exe file. This is what the problem is. MSBuild is looking for sgen.exe in this location and can’t find it. How do you fix that? You could change registry settings, but there is risk in that…and I told you earlier that you wouldn’t have to. Another option is to find a copy of sgen.exe and put it in that folder. From what I can tell sgen.exe is pretty stand alone and any version you find should work. I went to a slightly newer SDK version on my machine and copied the file from there.

![Step 4](http://farm1.staticflickr.com/700/21470168646_90a88cf5b3_z.jpg)

With sgen.exe now in the right folder, my build works just fine…so fine that removing the file keeps the build working and I wasn’t able to get a screenshot of the error for this post.
