---
layout: post
title: Home Networking - What and Why
categories:
  - Networking
tags:
  - networking
date: 2017-07-02 20:00:00
excerpt: Moving into the new house meant a new internet provider and the standard installation of home networking gear that exists in (hundreds of) thousands of houses throughout North America
authorId: donald_belcham
---
<img style="float: right;padding-left:10px" src="https://www.igloocoder.com/images/network-cables.jpg"/>

Late last year we moved into a new house. Leaving the other house was tough, and not just because I had built out a [fairly good networking solution](https://www.igloocoder.com/2014/03/25/A-solid-foundation/) for it. Moving into the new house meant a new internet provider and the standard installation of home networking gear that exists in (hundreds of) thousands of houses throughout North America. Not only did we have crap hardward, the installer obviously had taken the path of least resistence when running the wire from the street and locating it in the house. The best part of the installation was that the wire from the street entered into the mechanical room. The install or previous owners had also run a small mess of Cat5 to get from the mechanical room to a central location where the ISP's router was expected to be located. From that location, they had run more wire to an "office" room in another part of the house.

This setup wasn't a bad one, but it did have it's limitations. The main router had to sit along a wall in the eating area of the kitchen. That router was also the single wireless access point in the house. ISP provided hardware being what it is (substandard at best), the wifi wasn't stable and, in some locations of the house, there was no identifiable signal. The first 6 months living in the new house have been filled with a host of first world problems. But, being the first world, we had solutions at our disposal.

### Past experience
Our old home had similar issues and I solved many of them, but I also introduced a few different problems along the way. At it's roots that house used a Rosewill gigabit switch and a handful of DD-WRT powered routers. If nothing else, these devices were stable...after I solved the long-running issue of random router reboots that, ultimately, were being caused by a loose power plug.

Probably the biggest ongoing problem in that house was wifi handoffs. There was one DD-WRT wireless access point on each of the three floors in the house. If I moved from the basement to the main floor, my phone (or other device) would stay connected to the basement access point...even if the signal strength dropped to barely noticeable levels. The result was that you could be standing right next to an access point but you wouldn't be connected to it and you'd likely be suffering from a poor connection to another access point. Definitely not a good thing in a house of highly connected and frequently moving people.

There were a number of things that I really liked about the physical setup in that house, and I knew that I needed to carry them forward to the new one. One of those was the use of a patch panel where all of the wired connections in the house terminated. Being able to easily interact with the different locations throughout the house was a godsend many times. I added more than just the network cables to the patch panel. Using a Keystone based panel I was able to have all of the Cat5e cables in the panel, the coaxial cables and the phone lines all in that one place. Interestingly, I benefited from the patch panel flexibility more times with the coax and phone lines than I did with the network cables.

One of the other nice thing was the use of a [PDU in the rack](https://www.amazon.ca/StarTech-com-RKPW081915-19-Inch-Rackmount-Distribution/dp/B0035PS5AE/ref=sr_1_4?ie=UTF8&qid=1493169057&sr=8-4&keywords=rack+pdu). Instead of having multiple powered devices all searching for a wall plug and, ultimately, resorting to some kind of consumer power bar, I was able to nicely organize the power distribution.

The final "must have" that I learned in the old house was the use of a wall mount rack. Originally I had aspirations of using a 48U free standing rack for my networking and entertainment needs. Realistically I didn't need that much space. It wasn't just the vertical space of the free standing rack that was overkill, but also the depth. Most rack mount networking hardware doesn't need more than 20 inches of depth. A good wall mount rack can easily provide the depth required. A rack also saves you from having a bunch of crappy shelves holding one-off hardware and a tangle of cables. For me, a wall-mount rack was a must-have.

I did a lot of good things in the old house. I did a number of bad things too. My only goal was making home-network-v2 better than its predecessor.

### Needs
<img style="float: right;padding-left:10px" src="https://www.igloocoder.com/images/MaslowsHierarchyOfNeeds.jpg"/>

Obviously there were things I thought we needed in our new house network. They weren't "needs" in the same sense as [Maslow's Hierarchy](https://en.wikipedia.org/wiki/Maslow%27s_hierarchy_of_needs), but they sure felt important to me.

Top of the list, which I was constantly hearing about from the other people in the house, was strong, stable WiFi that covered all the areas we used around the house, the inlaw suite and the pool. The longer I waited to build this network, the more I was being reminded of how important this was to the other people in the house.

I also wanted to setup a good infrastructure base to build from. Strong hardware, good cable management and room for expansion. The expansion part was key. I have lots of plans.

### Wants
There are a lot of things that I want to do with a home network. A big one is supporting my desire to build a full sensor network to track things like water spills/leaks, windows, doors, and many other things. One of the biggest issues with adding those features to a house is that the sensor devices require power. The easiest solution to that was a PoE capable switch and a full 48 ports.

I also really wanted to completely eliminate all of the ISP provided hardware. The WiFi on it sucks, it reboots randomly and I have little or no control over the patching of it. The biggest challenge here is that the ISP router also provides our TV service.

One of the goals with moving to this new house was for me to spend some more time in a workshop making sawdust. I'd love to be 100% disconnected while doing that, but the reality is that I do a lot of research/learning about woodworking online. Some internet connectivity in my shop, which is about 150 feet from the house, was pretty high up on my list.

### Dreams
We all have them: plans for our "ideal" network. The platinum plated solution. I'm definitely not immune to this.

One of the things I hate the most about the default ISP provided solution is that all of the TV set-top boxes get their signals via WiFi. Obviously, the farther from the base unit, the more walls, bad weather, invisible temporary Faraday Cage's, days that end in 'Y' and other things will cause instability in the TV signals. I really wanted to get rid of this and go to a wired solution so that I would know that the TVs would all work whenever I needed to binge watch ~~Master Chef Junior~~ The Expanse. This is _not_ a normal way to configure this provider's TV sytems.

Another dream was to setup the telephone wiring in a patch panel like I had done at the old house. This might seem like a simple thing to do, but you haven't seen the wiring in the new house. It's a 40+ year old place that has had low voltage wiring cobbled together through its life. Getting all of the different phone jacks routed back to a central location was going to be no small task.

### Thinking and Planning and Thinking
I spent somewhere between 4 and 6 months formulating ideas, prioritizing them, re-thinking possible solutions and scrapping some of them. It was probably one of the best things that I could have done. Instead of rushing into any solution that looked and felt better than what was available when we moved in, I lived with what we had (much to the chagrin of the other WiFi users in the house). I didn't just go out and buy the hardware I thought I needed. I thought through the problem area, researched options, considered if the problem really would exist, looked for alternatives and then re-thought everything.

I discovered a lot of problems that I would have overlooked if I'd moved faster. Things like the importance of having system management solutions when you're using enterprise level hardware. I found a lot of hardware solutions that I didn't know existed. One of those was front and back cable management trays. I also scrapped a few ideas, like running a buried strand of fiber from the house to the garage.

There were a few adjustments and ideas that did surface that I couldn't ignore though.

### Adjustments
<img style="float: right;padding-left:10px" src="https://www.igloocoder.com/images/deskphone.jpg"/>

Our new house has the main living quarters and an attached in-law suite. When people are staying in the suite the only way to communicate with them is to walk to their door and knock or to call their cell phones. Since that space isn't going to be occupied full time, installing a separate land-line isn't a good option. I did, however, run across some information on open source VoIP solutions. All I needed was a PoE powered data line and I could put a phone anywhere in the house, inlaw suite or the garage. While not a "need" or a "want", this idea is certainly on the "dreams" list and likely will happen at some point in the future.

Another problem that I struggled to solve was how I could monitor people who came to the door of the inlaw suite. It is situated such that I can't see the door or the driveway from any part of the main house. I looked at some IoT-ish video doorbells, but none of them gave me the warm and fuzzies. One night I went down a rabbit hole around IP based video monitoring systems. Not only could I see who was knocking at the door, but I could also put some eyes on other parts of the yard like the detatched garage and the pool. IP based video was not just going to get added to the list or requirements, but it was going to apparear at the "want" level.

I read a lot of forums as I did research for this project. One night while looking for something completely unrelated I stumbled across a conversation that had an off-hand comment about the UPS that my ISP provides for some of their hardware. It turns out that the way this UPS is connected to the hardware, it only powered the phone functionality when it was running on the battery. That meant that all internet would be cutoff immediately when the power went out...even if there still was signal in the fibre lines. Prior to this little bit of information I had only intended on using a PDU in the rack. A quick trip to Amazon and I was expecting delivery of a 1U UPS that could provide battery backup to the UPS that provides battery backup to the ISP hardware. Because daddy can't be without his internet when the power bumps.

### Filled to overflowing
Our new house has a very nice wood burning fireplace in it, and I spent the better part of the winter sitting by it reading and researching all things networking. It was fun to spend time looking at concepts and problem areas that I used to work with early in my career. I'm not sure if it is the variety of new (to me) hardware and software, or the prospect of building v2 of something, but either way it is something that I was energized by.

Some of the other Western Devs have asked that I publish a bunch of content around this project, so this is just the first of many.