---
layout: post
title:  SQL Server Aliases
date: 2015-12-16T19:06:57-07:00
comments: true
author: simon_timms
originalurl: http://blog.simontimms.com/2015/12/17/sql-server-alias/
---

Ever run into that problem where everybody on your team is using a different database instance name and every time you check out you have to update the config file with your instance name?

Boy have I seen some complicated solutions around this involving reading from environments and having private, unversioned configuration files. One of the developers on my team recommended using SQL Server Aliases to solve the problem. I fumbled around with these for a bit because I couldn't get them to work. Eventually, with some help, I got there.

Let's say that you have an instance on your machine called `sqlexpress` but that your project needs an instance called `sqlexpress2012`. The first thing is to open up the SQL Server Configuration Manager. The easiest way to do this is to run

`SQLServerManager13.msc` 

where the 13 is the version number of SQL server so SQL 2014 is 12 and SQL 2016 is 13. That will give you 

![SQL Server Configuration Manager](http://i.imgur.com/XEwZzzl.png)

The first thing to check is that your existing instance is talking over TCP/IP. 

![Enable TCP/IP](http://i.imgur.com/eQRs5I5.png)

Then click on the properties for TCP/IPO and in the IP Addresses tab check for the TCP Dynamic Ports setting

![Dynamic ports](http://i.imgur.com/qQ4vy1y.png)

Make note of that number because now we're going to jump to the alias section. 
![Aliases](http://i.imgur.com/pRyXu6D.png)
Right click in there and add a new alias
![](http://i.imgur.com/wQeGUDU.png)
In here we are going to set the alias name to the new name we want to use. The port number is what we found above, the protocol is TCP/IP and the server is the existing server name. You then have to repeat this for the 64 bit client configuration and then restart your SQL server. You should now be able to use the new name, `localhost\sqlexpress2012` to access the server.