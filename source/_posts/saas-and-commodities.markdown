---
layout: post
title:  SaaS and Commodities
date: 2015-07-28T16:40:50+02:00
categories:
comments: true
authorId: donald_belcham
originalurl: http://www.igloocoder.com/2817/saas-and-commodities
alias: /saas-and-commodities/
---

I'm doing some work right now that requires us to send SMS messages. The organization I'm working with has never had this capability before so we are starting at ground level when it comes to looking at options. As part of our process we evaluated a number of different criteria on about four different SaaS options; [twilio][1], [plivo][2], [nexmo][3] and [sendinblue][4]. For reasons not relevant to this post, plivo was the initial choice of the client. We moved from analysis to writing a proof of concept.

<!--more-->

The first stage of doing a proof of concept is getting a user account set up. When I tried registering a new account with plivo I got the following message:

![plivo_error][5]

I did, however, receive an account confirmation email. I clicked on the link in the email and received the same message. Thinking that this might just be a UI issue and that the confirmation was accepted I decided to try to login. Click the login button and wham…same error message…before you even get to see the username and password screen. This, obviously, is starting to become an issue for our proof of concept. I decide, as a last resort, to reach out to plivo to get a conversation going. I navigate to the Contact Us page to, once again, see the same error message before I see the screen. At this point the website is obviously not healthy so I navigate to the status page and see this

![plivo_status][6]

So everything is healthy….but it's not. A quick glance at their twitter account shows that plivo attempted to do some database maintenance the day prior to this effort and they claimed it was successful. Related to the database maintenance or not, I needed to move on.

This is the part that gets interesting (for me anyways). Our choice in SMS provider was a commodity selection. We went the store, looked on the shelf, read the boxes and picked one. It very well could have been any box that we selected. But the fact that making that selection was so simple means that changing the selection was equally simple. We weren't (in this specific case which may not always be the case) heavily invested in the original provider so the cost of change was minimal (zero in our case). All we had to do was make a different selection.

This highlighted something that hadn't clicked for me before. Software as commodities makes our developer experience both more dynamic and more resilient. We are able to change our minds quickly and avoid unwanted interruptions easily. The flip side of the coin is that if you're a SaaS provider you need to have your A game on all the time. Any outage, error or friction means that your potential (or current) customer will quickly and easily move to a competitor.

[1]: http://twilio.com
[2]: http://plivo.com
[3]: http://nexmo.com
[4]: http://sendinblue.com
[5]: https://farm4.staticflickr.com/3739/19464256764_33dd8b79b9_z.jpg
[6]: https://farm1.staticflickr.com/318/19465913243_18bd4dca97_z.jpg
  
