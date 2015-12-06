---
layout: post
title:  Azure SQL Point in Time Restore Is Near Useless
date: 2015-08-13T19:11:45-06:00
categories:
description: Azure SQL Point In Time restores are so slow as to be near useless.
comments: true
author: simon_timms
originalurl: http://blog.simontimms.com/2015/08/14/azure-point-in-time-restore-is-useless/
---

About a year ago Microsoft rolled out Azure [point in time restore](http://azure.microsoft.com/blog/2014/10/01/azure-sql-database-point-in-time-restore/) on their SQL databases. The idea is that you can restore your database to any point in time from the last little while (how long ago you can restore from is a function of the database scale). This means that if something weird happened to your data 8 hours ago you can restore back to that point. It even support restoring databases that have recently been deleted.

My reading of the marketing material around this feature is that it is meant to replace full database backups in a number of scenarios. In fact if you go to do a database export you're warned about the performance implications and that point in time restore is much preferred. The problem is that it is slow.

Cripplingly. Shockingly. Amazingly. Slow.

The database I'm working with is about 140MiB as a backup file and just shy of 700MiB when deployed on a database server. Downloading and restoring the database on my laptop, a 3 year old macbook pro running an ancient version of Parallels takes between 6 and 10 minutes. Not a huge deal.

On azure I have some great statistics because restoring the database is part of our QA process. Since I switched from restoring nightly backups to using point in time restores I've done 45 builds. Of these 6 of them have failed to complete the restore before I gave up which usually takes a day. The rest are distributed like this in minutes

![Scatter!](http://i.imgur.com/LvegUyg.jpg)

As you can see 23 of restores, or 59% took more than 50 minutes. There are a few there that are creeping up on 5 hours. That is insane. This is a very small database when you consider that these S1 databases scale to 250gig.  Even if we take our fastest restore at 7 minutes and plot it out then this is a 29 hour restore process. What sort of a business can survive a 29 hour outage? If we take the longest then it is 47 days. By that time the company's assets have been sold at auction and the shareholders have collected 10 cents on the dollar.

When I first set this process up it was on a web scale database and used a backup file. The restore consistently took 15 minutes. Then standard databases were released and the restore time increased to a consistent 40 minutes. Now I'm unable to tell the QA team to within 4 hours when the build will be up.

Fortunately I have a contact on the Azure SQL team who I pinged about the issue. Apparently this is a known issue and a fix is being rolled out in the next few weeks. I really hope that is the case because in the current configuration point in time restores are so slow and inconsistent that they're in effect useless for disaster recovery scenarios as even for testing scenarios.
