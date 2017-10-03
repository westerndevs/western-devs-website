---
layout: post
title: Home Networking - Cabling
date: 2017-10-02 23:00:00
categories:
  - Networking
tags:
  - networking
excerpt: One of the things that I knew I wanted to do with this home network was run cables to as many places as possible
authorId: donald_belcham
---
<img style="float: right;padding-left:10px" src="https://www.igloocoder.com/images/raw-wiring.jpg"/>

One of the things that I knew I wanted to do with this home network was run cables to as many places as possible. Some were non-negotiable: 
 * the office needed multiple drops (8 in the end)  
 * the TV areas needed multiple drops  
 * each of the wireless access points needed a drop

I really didn't want to deal with pulling the cable into some of those areas. Hanging out in the attic wasn't way up on my list of fun things. And, to be honest, I had no clue how I was going to get cables from the main house into the attached in-law suite. So I called the local electrician. I needed a couple of circuits to power the equipment in the server rack so it seemed like something that would make sense to bundle together.

This was the best option. The electrician and his helper pulled about 1700 feet of Cat6 cable for me. Some were my required cables and a few were extras that they pulled to the attics so that I had extra capacity when I need it. They spent a bunch of time in the heat of the attic. They also pulled cables into wall cavities so that it looks like the house has always had Cat6.

All of the cable drops were pulled to the area that I was going to put the server racks. All of this is pretty basic stuff, but I did do one thing different than I did in my last house; I didn't cut the cables short on the rack end. Instead I terminated them into Cat6 female keystone jacks as close to the ends as possible.

This left a lot of extra cable by the rack. And that's fine. Heck, in the end I had to re-terminate a handful of the cables because I screwed them up or did them poorly.

> NOTE: It's worth buying a proper punch down tool if you're going to go do your own ends. Between my patch panel and the wall plates around the house I terminated about 50 keystones.

So what do you do with all that excess cable? You dress it of course. If you've never seen well dressed network cables, you need to spend a bit of time over at [https://cableporn.reddit.com](/r/cableporn). I hate messy cables. It could be my desk, behind the TV, or my networking stuff, so the people of /r/cableporn have a dear place in my heart.

I dressed all the excess cables into what's known as a "service loop". The loop provides you with an excess of cable really close to the rack. If you have to fix terminations you have extra cable that you can use. This was something that I didn't have at the old house and it almost bit me in the ass. So now I have a service loop attached right to the rack which gives me about 4-5 ft of extra cable. 

> I had so much excess cable that I ended up with a second service loop that has about 8ft of cable in it too...so I should never have short cable problems.

Having a service loop is great, but having a messy one is almost as bad as not having one at all. I bundled up all of the cables in the service loop using [velcro straps](https://www.amazon.ca/gp/product/B001E1Y5O6/ref=oh_aui_detailpage_o00_s00?ie=UTF8&psc=1). Not zip ties, velcro straps. You can easily undo them and move cables as needed. With zip ties I'd have to cut them and add new ones every time. It's also possible to over tighten a zip tie and end up cutting into the cabling...not good. Velcro straps were the right choice based on the amount of times that I had to loosen them to move cables.

<img style="float: right;padding-left:10px" src="https://www.igloocoder.com/images/rack-loop.jpg"/>

I probably could have bundled the cables better if I'd used a [cable comb](https://www.amazon.ca/ACOM-PIECE-CONTRACTOR-INSTALLATION-YELLOW/dp/B01BTUI1TQ/ref=sr_1_1?ie=UTF8&qid=1501120387&sr=8-1&keywords=cable+comb), but for the amount of cables that I had I didn't think buying one was worth it.

The only other Cat6 cable work that I did was to make a bunch of short cables to go between the patch panel and the switch. Yah, I probably could have bought them and saved myself a bunch of time. I needed something to do in my evenings, and getting them the exact length that I wanted would make the front of the panel look a little better too. 

So all that Cat6 cable management is great, but there are other cables in my rack area that needed to be managed too. The switches, routers, UPS, power distribution, etc all had power cables. Instead of running them all over the place to get them plugged in, I bundled them up too. I didn't bundle them with the Cat6 though. Power cables can cause interference in unshielded network cabling. So with the Cat6 service loop attached to one side of the rack, I bundled the power cables and ran them along the other side of the rack.

So cabling was important, and maybe I went a bit overboard on it for a house. I should never have issues with the cables I have, and if I do I have extra cable in the service loops to fix it. I have an organized rack cabling solution that makes it really easy to trace and replace/fix cables as required. It's also really easy to move things around, change ports being used, or completely remove hardware as needed.

Put some time into planning your cable needs, some effort into installing them, and some patience into organizing them. The end result will pay off.