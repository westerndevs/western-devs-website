---
layout: post
title: DDWRT and logentries
categories:
  - Networking  
date: 2016-02-16 23:10:46
tags:
  - Networking  
excerpt: "Logging DD-WRT system entries to the cloud"
authorId: donald_belcham
---
I've had [DD-WRT](http://www.dd-wrt.com/site/index "dd-wrt.com") setup on all the routers/repeaters in my house for a few years now. The platform, generally, is great. It has it's quirks, and you're not going to get my mother to install and administer it on her home network. Overall, I think it works just fine for a guy like me though.

Over the last few months I've been seeing some intermittent stability issues. It seems that at the most random times the main router in the house will lock up and not respond to any pings. I have to then go downstairs, unplug the router for 30 seconds and plug it back in. By the time I'm back upstairs at my computer it's all working again.

Thus far the disconnections haven't happened during any meetings. When you work from home, having that happen would be a royal pain in the ass. As it is, going up and down the stairs during a train of thought is a complete pain in the ass so I've wanted to get to the bottom of it.

### Logging in DD-WRT
By default logs for DD-WRT are stored in volatile memory. When you have to hard reset the router you, of course, lose those logs. This makes it really hard to track down the source of the problem.

An alternative is to log to the volatile memory location and then have a scheduled cron job to move those log files to an attached USB storage device. While this seems a bit better, you are never going to get the log entries that happened immediately before the router went down. There just isn't time for the cron job to run and it's on a schedule so it might not even be time for it to run.

A third option is to push the logging information to a remote server. Most examples out there show a configuration where the router is pushing the log entries to a computer on the internal network. This is all well and good, but I don't want to have to guarantee that my desktop/laptop is running to receive and archive that data.

Buried in [a wiki page on logging](https://www.dd-wrt.com/wiki/index.php/Logging_with_DD-WRT "Logging with DD-WRT") is mention of being able to log to a service called [Papertrail](https://papertrailapp.com/ "papertrailapp.com"). This got me thinking; I've logged from my [Arduino and Netduino](http://www.igloocoder.com/2015/04/09/Arduino-and-logging-to-the-cloud/) to [logentries.com](http://www.logentries.com "logentries.com") before. Why couldn't I configure DD-WRT to do the same thing?

### Configuration  
There are three steps you need to do to get DD-WRT to log to logentries.com.  

1. Setup a Log Set and Log on logentries.com  
2. Configure DD-WRT  
3. Restart DD-WRT  

##### logentries.com
If you don't already have one, create an account with logentries.com for their [Free Plan](https://logentries.com/pricing/ "logentries.com Pricing"). Once you're logged into the website, open the Logs tab. Then click the "+ Add New" button and select "Add a log".  

![](http://content.igloocoder.com/images/ddwrt-logentries-1.png)  

The will put you into the page where you select the type of logging source you're going to use. In the case of DD-WRT the logger is Syslogd so we select that one.

![](http://content.igloocoder.com/images/ddwrt-logentries-2.png)

In the Configure screen you will want to add this Log to a Log Set. If you're new to logentries.com you'll want to select "New Set" and type a meaningful name in (i.e. Home Router). If you already have logs on logentries.com you may want to use an Existing Set.

![](http://content.igloocoder.com/images/ddwrt-logentries-3.png)

The last step you need to take is to click on the "Create Log Token" button. This will open a bunch more information in a Configuration section of the same page.

![](http://content.igloocoder.com/images/ddwrt-logentries-4.png)

The only thing you need to worry about at this time is what appears in the first command area. In my case it's telling me to use `*.* @@data.logentries.com:13630` which includes the endpoint information. This information is what you will need for configuring DD-WRT so don't ignore it.

After you take note of the endpoint, you can click the "Finish & View Log" button. At this point your Log will be put into "Discovery Mode". You have 15 minutes to make the first call to this endpoint to activate it. That call to the logentries.com endpoint needs to happen from the IP address of your router. This will configure the Log to only accept data from that IP address.

![](http://content.igloocoder.com/images/ddwrt-logentries-5.png)

##### DD-WRT
Now that you have logentries.com configured you need to quickly move through the DD-WRT setup. Remember that you only have 15 minutes to get this done. It should be easy, but don't wander off to the bowels of YouTube to watch cat videos.

First step, log into your DD-WRT router's web interface and navigate to the Services tab.

![](http://content.igloocoder.com/images/ddwrt-logentries-6.png)

Towards the bottom of that page you will find the System Log section. Enable Syslogd and enter the endpoint information that you got from logentries.com earlier. You will want to ignore the `*.* @@` and only use the `data.logentries.com:XXXXX` portion, where XXXXX is the port that you were assigned.

![](http://content.igloocoder.com/images/ddwrt-logentries-7.png)

Once you have this done, click Apply Settings followed by the Save button. After you've added the settings you can click the Reboot Router button and wait for your router to come back online.

Once your router has come back online and you have internet access you should be able to go to logentries.com and see that the "Discovery on Port XXXXX" has changed to show the IP address of your router. When I did mine it took a couple of minutes for logentries.com to process in the incoming messages and make this change. If you don't see the IP address then you weren't successful in connecting your router to logentries.com. I didn't have the happen so the only suggestion I can give you is to verify that the Syslogd settings in DD-WRT were saved and then do a reboot of the router again.

![](http://content.igloocoder.com/images/ddwrt-logentries-8.png)

Once you have successfully connected the two systems you should be able to open the Log for your router and see the logging that occurs when it goes through it's startup process.

![](http://content.igloocoder.com/images/ddwrt-logentries-9.png)

You could stop at this point and have all your system logging taken care of. But you can go one step further and enable firewall logging if you want. Note that when I tried this it made my router horrifically unstable and I had to completely disable it to get more than 5 consecutive minutes of uptime.  
Open the Security | Firewall tabs and look to the bottom of the page. There, you will see a section for Log Management. Click Enable and set up the log levels and options as you desire.

![](http://content.igloocoder.com/images/ddwrt-logentries-10.png)

![](http://content.igloocoder.com/images/ddwrt-logentries-11.png)

### Conclusion  
Setting up DD-WRT and logentries.com isn't very difficult. DD-WRT can be a bit persnickety but otherwise it's a straight forward endeavour. Things you should note about this configuration:

- if your internet goes down you don't get logging
- I've not had my router freeze up since doing this so I'm not sure what, if anything, I'll capture
- if you only configure and run the Syslogd logging you will not get much activity in the log file

When my router craps out on me again I'll post something about what I saw, or didn't see, in the log files. 