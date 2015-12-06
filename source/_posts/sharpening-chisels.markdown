---
layout: post
title:  Sharpening chisels
date: 2015-07-08T13:38:46-04:00
categories:
comments: true
authorId: donald_belcham
originalurl: http://www.igloocoder.com/2785/sharpening-chisels
---

I'm working on a cedar garden gate for our back yard. It's all mortise and tenon joinery which means I make a lot of use of my [Narex][1] [bench][2] and [mortise][3] chisels. The more you use chisels the duller they get. Dull chisels cause you two problems; you can't be as precise with them, and you run the very real risk of amputating a finger. As much as I have two of each finger I really do want to keep all eleven of them. Getting tight fitting tenons requires fine tuning of their thicknesses by the thousandth of an inch. Both of those fly directly in the face of what dull chisels are good at…so tonight was all about sharpening them up.

There are a number of different ways that you can sharpen edged tools (chisels and hand planes). There are machines, you can use water stones, Arkansas stones, diamond stones or, my personal choice, the "[Scary Sharp Technique][4]". For those of you that couldn't be bothered click that link and read through the original usenet posting on the topic in detail (and who can blame you, this is a software blog after all) here's the TL;DR; for Scary Sharp.

* Sharpening is done with wet dry automotive sand paper, not stones
* Progression is made to finer and finer grits as you get sharper. i.e.  400 –> 800 –> 1200 –> 2000 grit
* Sandpaper is glued down to a perfectly flat surface such as float glass, a tile, or granite counter top (ask the missus first if you're planning on using the kitchen)

My station for tonight looked like this (400 grit to the left, 2000 grit on the far right):

![sharpening station][5]

So, why am I boring you with all this detail about sharpening my chisels? There's a story to be told about software tools and woodworking tools. The part of it that I'm going tell in this post is the part about maintaining and fine tuning them.

### Maintaining your tools

For me to be able to effectively, and safely, create my next woodworking project I need to constantly maintain my chisels (amongst other tools). I have to stop my project work and take the time to perform this maintenance. Yes, it's time that I could be getting closer to being finished, but at what cost? Poor fitting joinery? Avoidable gouges? Self amputation? The trade off is project velocity for project quality.

Now think about a development tool that you use on a regular basis for your coding work. Maybe it's Visual Studio, or IntelliJ, or ReSharper, or PowerShell, or…or…or. You get the point. You open these tools on an almost daily basis. You're (hopefully) adept at using them. But do you ever stop and take the time to maintain them? If it weren't for auto-updating/reminder services would you even keep as close to the most recent release version as you currently are? Why don't we do more? I currently have an install of Resharper that I use almost daily that doesn't correctly perform the clean-up command when I hit Ctrl-Shift-F. I know this. Every time I hit Ctrl-Shift-F I cuss about the fact it doesn't work. But I haven't taken the time to go fix it. I've numbed myself to it.

Alternatively, imagine if you knew that once a week/month/sprint/ you were going to set aside time to go into the deep settings of your tool (i.e. ReSharper &#124; Options) and perform maintenance on it. What if you smoke tested the shortcuts, cleaned up the templates, updated to the latest bits? Would your (or mine in the above example) development experience be better? Would you perform better work as a result? Possibly. Probably.

### Tools for tools

I have tools for my woodworking tools. I can't own and use my chisels without having the necessary tools to keep them sharp. I need a honing guide, sand paper, and granite just to be able to maintain my primary woodworking tools. None of those things directly contribute to the production of the final project. All their contributions are indirect at best. This goes for any number of tools that I have on my shelves. Tools for tools is a necessity, not a luxury. Like your first level tools, your second level of tools need to be maintained and cared for too. Before I moved to the Scary Sharp system I used water stones. As you repetitively stroke the edge over the stone it naturally creates a concave in the middle of the stone. This rounded surface makes it impossible to create a proper bevel angle. To get the bevel angle dead on I needed to constantly flatten my stone. Sharpen a tool for a while, flatten the stone surface…repeat. Tools to maintain tools that are used to maintain tools.

Now think about your software development tools. How many of you have tools for those tools? Granted, some of them don't require tools to maintain them….or do they? So you do some configuration changes for git bash's .config file. Maybe you open that with Notepad ++. Now you have a tool (Notepad++), for your tool (git bash). How do you install Notepad++? With [chocolatey][6] you say? Have you been maintaining your chocolatey install? Tools to maintain tools that are used to maintain tools.

Sadly we developers don't put much importance on the secondary and tertiary tools in our toolboxes. We should. We need to. If we don't our primary tools will never be in optimal working condition and, as a result, we will never perform at our peaks.

### Make time

Find the time in your day/week/sprint/month to pay a little bit of attention to your secondary and tertiary tools. Don't forget to spend some quality time with your primary tools. Understand them, tweak them, optimize them, keep them healthy. Yes, it will take time away from delivering your project/product. Consider that working with un-tuned tools will take time away as well.

[1]: http://www.narexchisels.com/Narex_Chisels/Home.html
[2]: http://www.leevalley.com/en/wood/page.aspx?p=67707&cat=1,41504
[3]: http://www.leevalley.com/en/wood/page.aspx?p=66737&cat=1,41504
[4]: https://groups.google.com/forum/?hl=en#!topic/rec.woodworking/rGAGAPR-6ks
[5]: https://farm1.staticflickr.com/373/19487481376_c527907bae_z.jpg
[6]: https://chocolatey.org/
  