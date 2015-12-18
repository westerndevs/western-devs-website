---
layout: post
title: "The Case of the Disappearing Database"
date: 2015-12-03 16:29:09
comments: true
authorId: dave_paquette
originalurl: http://www.davepaquette.com/archive/2015/12/03/the-case-of-the-disappearing-database.aspx
alias: /case-of-the-disappearing-database
---

Something scary happened last week. The database backing my blog disappeared from my Azure account.

**Some background**: At the time, my blog was a Wordpress site hosted as an Azure Web Site with a MySQL database hosted by Azure Marketplace provider ClearDB.

## Series of events
At approximately 12:01 PM I received an alert from Azure that my blog was returning HTTP 500 errors. I quickly checked the site to see what was happening and I was seeing the dreaded "Error establishing a connection to the database" message. I had seen this in the past because I was hosting on a very small MySQL instance. It was not entirely uncommon to exceed the maximum number of connections to my database. The thing is that I had recently upgraded to a larger database instance specifically to avoid this problem.

So...I logged in to the Azure Portal to investigate. To my horror, the MySql database for my blog was nowhere to be found!!! It was gone from the Azure Portal entirely and I couldn't find it on the ClearDB website either. I am the only person who has access to this Azure account and I know that I didn't delete it.

I quickly opened an Azure support ticket and contacted ClearDB to see if either company could tell me what happened to my database.

ClearDB actually responded quickly:

> Our records indicate that a remote call from Azure at Wed, 25 Nov 2015 12:00:34 -0600 was issued to us to deprovision the database

Ummm WTF! I know I didn't delete the database. It seems that there is some kind of bug in the integration between Azure and ClearDB. In the mean time, Azure Support eventually replied with the following:

> I have reviewed your case and have adjusted the severity to match the request. Sev A is reserved for situations that involve a system, network, server, or critical program down that severely affects production or profitability. This case is set to severity B with updates every 24 hours or sooner.

After nearly a week, I received another update from Azure support:

> I have engaged our Engineering Team already to investigate on this issue and currently waiting for an update from them. Our Engineering Team would require 5 to 7 business days to investigate the issue, I will keep you posted as soon as I hear from them.

I am curious to see what the Engineering Team comes back with. I will update this post if / when I hear more.
 
## Restoring from backup

With my database gone, my only choice was to restore from backup. This should have been an easy task. Unfortunately, my automated backup wasn't actually running as expected and my most recent backup was 7 months old. I had all my individual posts in Live Writer `wpost` files but republishing those manually would have taken me over a week.

<!--more-->

In the end, ClearDB was very helpful and was able to restore my database from their internal backups. As a result, my blog was down for a little under 24 hours. 

## Lessons learned

These were hard lessons for me to learn because I already knew these things. Problem was that I wasn't treating my blog like the production system that it is.

- Don't trust the cloud-based backups. ClearDB has automated periodic backups but I lost access to those when my database was mysteriously deleted. Have a backup held offsite. That's what my Wordpress backups were supposed to do for me, which brings me to my second point.

- Test your backups periodically. I had no idea my backups weren't working until it was too late. 

- Complexity kills. I have a simple blog and my comments are managed by Disqus. There is really no reason I should need a relational database for this. The MySQL database here has been a constant source of failure on my blog. 
 
## Moving on

Once my blog was restored I quickly started a migration over to Hexo. I will blog more about this process shortly.


