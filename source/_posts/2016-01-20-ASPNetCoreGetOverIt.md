---
title: ASP.net 5 is now ASP.net Core 1.0, Get Over It
layout: post
tags:
  - ASP.NET 5
  - ASP.NET Core
categories:
  - News
authorId: simon_timms
excerpt: "What the rename was and why it is just right"
---

You know who I love? Simon Timms, that's who I love. And the thing with love is that you can disagree about something, but that doesn't mean you stop loving.

So with that said, let me tell you what's WRONG [with his recent post about the renaming of ASP.NET 5 to ASP.NET Core 1.0.](http://www.westerndevs.com/News/ASP-Net-5-rename/)

Actually my first beef isn't with Simon, its with Scott.[ Do we really have to be all dramatic about how "ASP.NET 5 is DEAD"?](http://www.hanselman.com/blog/ASPNET5IsDeadIntroducingASPNETCore10AndNETCore10.aspx) It's not dead, its just being renamed. Let's not make this more dramatic than it needs to be.

### The Issue ###

Back to Simon's post. The problem he seems to have is the legacy attachment to the term ASP. For those who weren't doing web development in the late 90's, ASP (Active Server Pages) was a Microsoft technology for creating dynamic web applications. You added VBScript into your web pages to make it render things, which was processed on the server. When .NET came out, Microsoft kept the ASP name for their .NET based web technology - ASP.NET was born. Over the years ASP.NET has become a catch all for all sorts of Microsoft web tech - Webforms, MVC, Ajax, etc. There's an established base of developers who know and understand what ASP.NET means.

### What's in a Name? ###

And that matters. Having a reference point to a technology for the masses that already associate Microsoft web technologies to ASP.NET matters a lot. It matters in technology adoption, it matters in approachability, it matters in how easy it is to sell new developers on something.

I don't think the ASP name is kept to communicate that "it isn't any different" as Simon suggests. It's kept to give people a reference point; it encourages people who are attached to ASP.NET technologies to look at this new Core 1.0 offering. Consider these two conversations.

****

"Hey, have you guys checked out the new web framework SimonSays?"

"No...we do ASP.NET.

"Oh...no, it's from Microsoft!"

"Yeah, so was Silverlight. We'll stick to our proven framework"

****

"Hey, have you guys checked out the new web framework ASP.NET 1.0 Core?"

"Oh...we do ASP.NET...I didn't realize there was a new framework out? What's all this about?"

****
And that is where the human element comes into play. People don't like change - that's why we have all these adages that "change is hard". Remember when Coke changed their recipe? They didn't change the name, they just said it was "New" Coke. Why? Because Coke as a brand was important to people...it meant something...it was a point of reference. ASP.NET is the same thing, its a brand...a point of reference.

Let's look at Simon's other point: "People shouldn't be moving to your framework because of subterfuge they should be moving because it is legitimately better. ASP.NET Core is legitimately better."

*People should do the right thing because the right thing is the right thing.* 

If this were true, we wouldn't have an entire job category called Sales and Marketing. Also, this assumes that a well architected system based on ASP.NET 4.6 is somehow null and void since ASP.NET Core 1.0 is out. Of course it isn't - the value of a system does not lie in what technology it was written in but in how much value it provides its users.

Please read that last line again. Would I ever write something new in COBOL? No. Does that invalidate reliable, running systems written in it today? Of course not.

So this leaves us with a new platform that we must now sell to developers - not in a money sense, but in a "please try it, please learn it, please understand what issues this solves in our previous technologies". And what better way to introduce something new than to give people a familiar frame of reference - ASP.NET.

### About That 9-5 Comment... ###

Not directly associated with ASP.NET but a point I'll still address is the blanket assumption of what a "9-5" developer is. I'm going to tell you a big secret that I've learned while being at a 9-5 public entity - the reason that most devs don't move forward with new technology is because they're busy maintaining the systems they already have. Being able to test out a new framework or a new tool comes in spurts as greenfield projects come up, not as a design choice because some vendor released something new. And if you talk to those 9-5ers you may find that while the technology might not be bleeding edge the problems they are solving are pretty impressive. ASP.NET Core 1.0 is not beyond a 9-5ers ability.

What Simon doesn't do in his post, and what I'd love to hear, is what he thinks it SHOULD have been named. What name would have opened the door to all those new non-Microsoft developers while at the same time given existing ASP.NET devs a reason to even look its way when they have a moment to come up for air?

How about...Silverlight?

