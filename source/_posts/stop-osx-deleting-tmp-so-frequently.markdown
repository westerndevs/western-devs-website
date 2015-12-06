---
layout: post
title:  Stop OSX deleting /tmp so frequently
date: 2015-10-04T23:32:11-06:00
categories: docker
comments: true
authorId: simon_timms
date: 2015-11-06T19:19:27-07:00
---

Some time ago I lost a podcast recording because I stored it in /tmp. It is a bad habit but I tend to store things that I'm not going to need in the long run in /tmp. It is a throw back to my real Linux days when storage was expensive and I might not be back on that machine for a while to figure out why all the space was used. 

By default OSX deletes the contents of /tmp when it is 3 days old, or rather it hasn't been accessed for 3 days. This is found by using `find -atime +3` (you can read all about that in the man page for find). In order to avoid losing any more important things I decided to change this from 3 days to 90 days. To do this you'll want to edit the /etc/defaults/periodic.conf file and find the variable called `daily_clean_temps_days`. In my file it looks like

{% codeblock lang:bash %}
# 110.clean-tmps
daily_clean_tmps_enable="YES"                           # Delete stuff daily
daily_clean_tmps_dirs="/tmp"                            # Delete under here
daily_clean_tmps_days="3"                              # If not accessed for
daily_clean_tmps_ignore=".X*-lock .X11-unix .ICE-unix .font-unix .XIM-unix"
daily_clean_tmps_ignore="$daily_clean_tmps_ignore quota.user quota.group"
                                                        # Don't delete these
daily_clean_tmps_verbose="YES"                          # Mention files deleted
{% endcodeblock %}

I went to line 4 and changed that 3 to a 90. Now <a href="http://www.westerndevs.com/bios/kyle_baley/">Kyle</a> won't be disappointed in me again. Well not disappointed about this. 