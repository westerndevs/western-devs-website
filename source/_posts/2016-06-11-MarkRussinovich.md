---
title: How I fixed OneDrive like Mark Russinovich
layout: post
categories:
  - debugging
authorId: simon_timms
date: 2016-06-11 18:56:56
excerpt: "Even with compiled applications it is possible to debug issues"
---

Fellow [Monster David Paquette](http://aspnetmonsters.com) sent me a link to a shared OneDrive folder today with some stuff in it. Clicking on the link I was able to add it to my OneDrive. The dialog told me files would appear on my machine soon. So I waited.

After an outrageously long time, 37 seconds, the files weren't there and I went hunting to find out why. As it turns out OneDrive wasn't even running. That's suppose to be a near impossiblity in Windows 10 so I hopped on the Interwebernets to find out why. Multiple sources suggested solutions like clearing my credentials and running `OneDrive.exe /reset`. Of course none of them worked.

Something was busted.

Running the OneDrive executable didn't bring up the UI it didn't do any of the things the Internet told me it should. My mind went back to when I was setting up my account on this computer and how I fat fingered `stimm` instead of `stimms` as my user name. Could it be the OneDrive was trying to access some files that didn't exist?

Channeling my inner Mark Russinovich I opened up `ProcessMonitor` a fantastic tool which monitors file system and registry access. You can grab your own copy for free from [https://technet.microsoft.com/en-us/sysinternals/bb896645.aspx](https://technet.microsoft.com/en-us/sysinternals/bb896645.aspx).  

In the UI I added filters for any process with the word "drive" in it and then filtered out "google". I did this because I wasn't sure if the rename from skydrive to onedrive had missed anything. Then I ran the command line to start up OneDrive again.

Process monitor found about 300 results before the process exited. Sure enough as I went through the file accesses I found
![http://i.imgur.com/soAh4PR.png](http://i.imgur.com/soAh4PR.png)
Sure enough OneDrive is trying to create files inside of a directory which doesn't exist. Scrolling further up I was able to find some references to values in the registry under `HKCU\SOFTWARE\Microsoft\OneDrive` which, when I opened them up, contained the wrong paths. I corrected them
![http://i.imgur.com/arhWYgt.png](http://i.imgur.com/arhWYgt.png)
And with that in place was able to start up OneDrive successfully again and sync down the pictures of cats that David had sent me.

The story here is that it is possible, and even easy, to figure out why a compiled application on your machine isn't working. By examining the file and registry accesses it is making you might be able to suss out what's going wrong and fix it.
