---
layout: post
title: "Paper Cuts - My Review of PaperCall.io"
date: 2017-03-07 11:30:00
categories: 
    - conference
    - services
excerpt: My experience using PaperCall.io, a conference session submission service.
comments: true
authorId: darcy_lussier
---
## Conference Time

My next [Prairie Dev Con](http://www.prairiedevcon.com) is coming up June 6-7 2017, and this year I decided to use a service that's become very popular for speaker submissions called [PaperCall.io](www.papercall.io). For speakers this service is fantastic - for free you can create a profile and add any number of talk abstracts. Then when a call for speakers opens, you can easily with just a few clicks submit any number of talks.

People can create events and open call-for-papers (CFP's) for free as well. Conferences are then included in their Open CFP list, with certain paid-level events getting "featured" treatment at the top of the list.

This creates a very attractive ecosystem for speakers and events, and removes the need for conferences to build their own system or use tools (i.e. SurveyMonkey) that weren't built specifically for conference session submission.

So that's the backdrop for the rest of this post. I went in very much looking forward to using PaperCall.io and I'm still very optimistic about the platform! But there are some crucial pain points that need to be addressed before I'd consider using it again for one of my conferences.

## Issue 1 - The Grid

When you have people submit their talks, the conference view displays them in a grid as per the image below.

!["PaperCall Grid"](https://darcyblogimages.blob.core.windows.net/wdimages/PC_Grid.JPG)

I want to point out a few things about the grid.

### 20 Record Per Page Limit

There's paging, but it limits you to 20 records per page. You can't change this to see larger number or even all.

### No Sorting By Speaker

The headings you see are what you get. You can't do a sort by Speaker for instance. You also can't add your own columns so if you wanted to sort based on location you're out of luck.
There is a search box, but that's only useful once you know what you're looking for (i.e. speaker name, location, etc.).

### No Bulk Status Update for Free Tier

Talks can be Submitted, Accepted, Rejected, or Waitlist (Declined is reserved for speakers who are accepted but decline after the fact I guess). Setting a talk to one of those settings via the drop list actually triggers a post back (let me check...yes, we're in 2017 here). So if you have 10 talks that you want to set as accepted, you have to manually one at a time set their drop list value to Accepted. This feature is listed in the Professional tier, but I don't know how its implemented.

### No Filtering

You can't set filters on the data either.

### Rating Style Doesn't Display

I selected the "Simple" rating style (yes, maybe, no) compared to Five Star, but the Five Star is what was displayed in my grid.

## Issue 2 - Downloading Submissions

So why not just download the data and manipulate it outside of PaperCall? If the service is supposed to be a one-stop-shop, then I shouldn't need to. I should be able to manage my speakers however I want within the application. But since we're limited to the grid as it is, exporting the data is the next best thing. Unfortuntaely you can only get to your data if a) you're on the paid tier, or b) you've identified talks as being Accepted. That's right - you have to go through the grid interface and assign statuses before you can export your own data (if you're using the free tier). Also note that the only download option you have is for Accepted talks, not Rejected or Waitlisted. If you're on the paid tier there's an API you can connect to...more on the pricing and features of the tiers later though.

## Issue 3 - Speaker Communication

I'm a fan of having an end-to-end ecosystem for speakers and conference organizers, but the speaker communication suffers from a few clunky parts.

### No Email Contact

Unless the speaker specifically puts their email address or Twitter handle into their profile, there's no way to communicate outside of the PaperCall "Communications with Speaker" mechanism. One of the problems with this is its tied ot a speaker AND a talk. So if you want to communicate with a speaker about 3 of their talks, you either pick one talk and include all the communication there (which ties it to the selected talk) or you break it up over the three talks. You get an email notification about the communication, which has a From that looks like this...

reply+ASERWQREWQREWQGASGAERWFSAFDFSAGHG343243242SFAFwerwfewf223432FRSDFDSFSF23GFSGWGWGEWFEWDE2FEWGWGWGWEFEWFEWFEWGEWGEWGEWGF32432432FEWFEWFFR32R32FSF==@mg.papercall.io

(that's not a real one, and its actually a longer address)

I find it looks messy and unprofessional.

### No Speaker Search for Organizers

As a conference organizer I have no way to search the speaker profiles. They aren't public (at least at the free tier), and unless a speaker sends you their URL there's no way to get to it. I understand that this model puts the power in the hands of the speakers and prevents conferences from blanketing speakers with harassing communication about their event - I'm on board with that. But if I have a speaker who's submitted a talk to my event, it would be great to be able to see all the talks that speaker could present. Perhaps I really like the speaker but their submitted talk isn't a right fit, or has been filled by someone else already, or whatever. It would be great to see other talk options. Currently I would have to request that via the speaker communication channel mentioned above.

### Accepted/Rejected Communication Confusion

Once you've identified talks as Accepted or Rejected you can then send an email message to the speakers letting them know. There's an issue though - you're accepting or rejecting the talk, not necessarily the speaker. I could have a speaker have 2 talks accepted but 3 rejected. With how the email works, that speaker would get "Unfortunately your talk was not picked. Thanks for applying, and I hope we see you as an attendee (that's a paraphrase to the stock verbiage sent out)." but then they'd get "Congratulations, your talk was picked" as well! That's confusing. I imagine speakers get multiple emails as well, since one seems to be sent for each session submitted. UGH! 

The way I avoided this was to assign rejected sessions for speakers who were actually accepted into the Waitlist group. Definitely a workaround/hack solution.

### Speaker Headshots Default to Gravatar

Although the interface seems to suggest that you can upload your own headshot, my Accepted Talk export provided a bunch of links to headshots that defaulted to the Gravatar for the person (if they don't have one, its the stock imgage). Not the worst thing in the world, but not the most ideal either.

## Issue 4 - Pricing

There's three tiers for PaperCall - Community (Free), Professional ($499 USD/event), and Custom. I'll ignore Custom for now and focus on the Community and Professional.

!["PaperCall Pricing"](https://darcyblogimages.blob.core.windows.net/wdimages/PC_Pricing.JPG)

Over Community, Pro provides:
* 15 more organizers
* Unlimited submissions
* Read-Only API Access + Webhooks
* Bulk Tagging/Submission Management
* Privately Tag Your Submissions
* Added promotion on the homepage
* 24 Hour email support

So for $500 I still have to use the web site to manage my data, as the API is read-only. I can add private tags, but that means I can filter by search only and not in the grid. Also I'm thinking there's no way to bulk-tag talks.

Let me frame this in the context of Prairie Dev Con. I typically get under 200 sessions submitted. I'm the only organizer (even if I added more organizers, I can't see it going beyond 5). The *only* thing $500 gets me is the read-only API so I can export my data and 24 hour email support. This is a tough justification.

If the grid had a better interface, I was able to better communicate with speakers, and I could export my data whenever I wanted to work on it offline, I would absolutely pay $200 per event for the service...maybe even $300. And I think there are MANY conferences that are mid-range that would be open to that tier level. As it stands now, the mid-range conferences are likely looking to make the Free tier work and the mega conferences that are using the paid tier are getting a crazy deal.

## In Conclusion

I love the idea of PaperCall. Speakers are on board, and through PaperCall I've had speakers submit that normally wouldn't have even known about my conference. But its definitely in need of some improvements, especially at the price points they've listed. All of my criticisms in this post are meant to share how to make the product better because I *want* PaperCall to be better!

But let's be honest, CFP isn't a complicated business process and there's no reason a competitor could come up with a better process. It's in PaperCall's best interest to listen to their customers, especially those willing to become paying customers if only certain functionality is added. We'll see if any advancement is made come later this Spring when I open up PrDC Deliver CFP.


