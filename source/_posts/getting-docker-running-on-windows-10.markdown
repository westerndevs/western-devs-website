---
layout: post
title: "Getting Docker running on Windows 10"
date: 2015-08-14 1:30:00
author: dave_white
originalurl: http://agileramblings.com/2015/08/14/getting-docker-running-on-windows-10/
comments: true
---
Just a quick post about a couple things I've learned yesterday and today.

Docker is now available to run on Windows 10. I'm not going to go into the details as they are better covered in other posts, but I'll share the steps I followed to get Docker running on my Windows 10 laptop.

![Docker-Windows-10][1]

### Visit David Wesst's Blog post (cross-posted to Western Devs)

Dave was the first of the Western Dev guys to talk about trying to get Docker working on Windows 10. He blogged about his adventure and that is where I started.

[http://blog.davidwesst.com/2015/08/docker-on-windows-10-problems](http://blog.davidwesst.com/2015/08/docker-on-windows-10-problems)

[http://www.westerndevs.com/docker-on-windows-10-problems](http://www.westerndevs.com/docker-on-windows-10-problems)

### Visit the Docker GitHub site

Dave's post directed me towards a couple other places. Namely, the Docker issues GitHub site and the Docker windows installation page.

[https://docs.docker.com/installation/windows](https://docs.docker.com/installation/windows)

This was pretty important because it was where the conversation about getting Docker (more accurately, VirtualBox) running on Windows 10. There is an issue in VirtualBox (current stable build) that does not allow it to work on Windows 10. This issue has been resolved in a Test build. The link to the test build is here.

[https://www.virtualbox.org/wiki/testbuilds](https://www.virtualbox.org/wiki/testbuilds)

I didn't actually need to go to the VirtualBox website to get the build because the latest test version of the Docker for Windows installer has the test version of VirtualBox already inside of it. You can find the link to the current test installer here.

[https://github.com/docker/toolbox/issues/77](https://github.com/docker/toolbox/issues/77)

### Follow the start up direction

The next thing I did was follow all of the start-up directions from the docker windows install documents. VirtualBox was installed, all of the Docker Toolbox items where installed, and so I fired it all up. And it didn't work. What was going on? The VM very quickly informed me that it couldn't find a 64bit cpu/os which is required to run docker.

>**This kernel requires an x86-64 CPU, but only detected an i686 CPU. Unable to boot – please use a kernel appropriate for your&nbsp;CPU**

Well, that was weird. I have an modern laptop (Dell XPS 15) running 64 bit Windows 10 Enterprise. What could be the problem? Google Foo to the rescue!

First I found posts suggesting that the CPU Intel Virtualization Technologies were not enabled. I didn't think that was true because I had already been running some HyperV machines on my laptop, but I did re-boot into my BIOS and ensure that Intel VT-x/AMD-V where enabled. They were.

So google a bit more, and I find that Virtual Box might need me to change the "type" of the VM to "Other" and the OS to "Other/64bit" or something like that. But interestingly enough, those were not options that I had in the VM.

![VirtualBox-OS-Options][2]

This screenshot was taken after the fix (which I'm getting to) but originally, none of the 64 bit versions of the OSes were available as a choice.

![VirtualBox-OS-bit-options][3]

One last thing I found was to remove the HyperV feature from Windows 10, but that wasn't a viable option for me. I have some HyperV virtual machines that I run (and need to run) so I didn't even explore that option.

At this point, I worked around for a bit and then gave up for the evening. Better to sleep on it and see if I could start fresh in the morning.

### Scott Hanselman to the Rescue

I'm not sure what search I did in the morning that got me to Scott Hanselman's post. I should really just always go there first because I find so much good information about Windows development (native and cross-platform) there. But specifically, it was this post that finally solved my problem.

[http://www.hanselman.com/blog/switcheasilybetweenvirtualboxandhypervwithabcdeditbootentryinwindows81.aspx](http://www.hanselman.com/blog/switcheasilybetweenvirtualboxandhypervwithabcdeditbootentryinwindows81.aspx)

I didn't know this until today, but as it turns out, HyperV and VirtualBox will not run together side-by-side in 64 bit modes. And Scott's blog post about rebooting to a **hypervisorlaunchtype off** mode of Windows 8.1 worked flawlessly for Windows 10. So I didn't have to un-install the HyperV feature, but as it turns out, I did have to disable HyperV. I'm sure glad I don't have to add/remove it daily though!

### Final Thoughts

So that was it! Thanks to [David Wesst][4], [WesternDevs][5], [Docker ][6]and [Scott Hanselman][7], I now have Docker running on my Windows 10 laptop. Just not at the same time as my HyperV virtual machines. :D

[1]: https://agileramblings.files.wordpress.com/2015/08/docker-windows-10.png?w=600&amp;h=308
[2]: https://agileramblings.files.wordpress.com/2015/08/virtualbox-os-options.png?w=450&amp;h=330
[3]: https://agileramblings.files.wordpress.com/2015/08/virtualbox-os-bit-options.png?w=450&amp;h=330
[4]: http://blog.davidwesst.com/
[5]: http://www.westerndevs.com/
[6]: https://www.docker.com/
[7]: http://www.hanselman.com/
