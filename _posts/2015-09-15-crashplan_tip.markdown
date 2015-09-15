---
layout: post
title:  CrashPlan Tip - Move the cache directory
date: 2015-09-15T10:19:12-06:00
categories:
comments: true
author: simon_timms
---

I use CrashPlan to back up my collection of computers. It is a great tool and has saved me on a number of occasions. Most memorably was the time that I forgot the password for my comically well-encrypted drive. Restoring from crash plan got me back all the important things. 

On my main machine I'm running out of disk space at an alarming rate. I have a 256GiB SSD in there as well as a 2TB spinning rust. I have tons of room on the rust drive but my SSD, which once seemed very large, is getting full. I cleaned up all I could but was still out of luck. A trip to [NCIX](http://ncix.com) and [MemoryExpress](http://memoryexpress.com) told me I was looking at between $250 and $350 for a 500GiB Samsung 850 EVO or Pro. I'd write it off as a business expense but I'd still rather have the money. I downloaded and installed a disk space tool called [Space Sniffer](http://www.uderzo.it/main_products/space_sniffer/index.html). 

![Image from the How-To-Geek](http://i.imgur.com/SZXsBSC.png)

Running this tool suggested that something like 15GiB of my space was being used by the CrashPlan cache. I guess this is used to speed up restores and backups in CrashPlan. Considering that my entire CrashPlan backup on this machine is only something like 25GiB that seemed excessive. Googling about I found an [unsupported How-To](http://support.code42.com/CrashPlan/Latest/Troubleshooting/Reassigning_Cache_Folder_To_A_Different_Directory) from CrashPlan that talked of how to move the cache. Following these steps and moving my cache directory off of fast disk worked perfectly. I am back up to a bunch of free space and I can defer the cost of a new drive for another year. 