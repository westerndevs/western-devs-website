---
title: Truly syncing multiple calendars
authorId: kyle_baley
date: 2024-06-17
mode: public
---

Very reasons that I really need to investigate, I'm apparently a busy fellow. Such that I now maintain a rather ungainly number of calendars. Three to be exact. That's one personal calendar and one for each of two clients.

It's a fairly simple process to _view_ all of these calendars in a single place. All the major calendar providers generously provide iCal links at the very least to let you combine everything in a single view and you can even turn individual calendars on and off.

I have two problems with this.

First, I often don't want to have all of these calendars visible in a single view on my screen. Screen-sharing is common and on more than one occasion, I've said, "let's schedule a meeting" and switched to the shared calendar view where all my personal [Dudeism meetings](https://en.wikipedia.org/wiki/Dudeism) are there for all to see.

Second (and more important than risking an argument with a nihilist), people booking meetings with me don't see the unavailable slots on the other calendars, leading to double-bookings. I didn't know how good I had it in high school when this was...let's just say, "not a problem".

So I went on the hunt for a solution that met these criteria:

1) The ability to book an event on one calendar and have the time blocked on the other two.
1) Have the time on other calendar show as a generic "busy" or "unavailable". I.e. don't broadcast the details of the events from other calendars.
1) Have a centralized view _somewhere_ of all the events _without_ duplicates. I.e. without a bunch of "busy" or "unavailable" events.
1) Ideally, works with both Google and Microsoft calendars

![The early days of online meetings](/images/flintstones-camera.jpg))

The easiest way to achieve this, of course, is to do it yourself. When you book an event on one calendar, you go through the motions of creating a generic event on the other two. This meets all the criteria but depending on how heavily your client leans into the "all meetings/all the time" project management style, this gets old real fast. But to be fair, it's served me reasonably well for many years.

This led naturally to a search for a technical solution, which yielded the following options:

- [OneCal](https://www.onecal.io/)
- [CalendarBridge](https://calendarbridge.com/)
- [Fantastical](https://flexibits.com/fantastical)
- [Calendly](https://calendly.com)
- [Reclaim.ai](https://reclaim.ai/)
- [Spike](https://www.spikenow.com/)
- [Syncing calendars](https://www.calendar.com/blog/how-to-sync-your-calendar-across-all-devices/)

I have OneCal at the top because it's (currently) my favorite option. But I'll skim through the rest and provide reasons why I didn't go with them. I'll use my tried-and-true practice of claiming that my choice is the One True Way™ and everyone else is wrong as a means of encouraging people to comment with their own options, if only to prove me wrong. Which I'm quite happy to be. But still, that's not the case here. I'm right and you're wrong. Comment below if you disagree.

Back to the evaluations. I'll start with some of the quicker ones.

### Syncing calendars

I'll be honest, I just kind of skimmed this article. I have kind of a vague idea of what they're going for but this seems geared more toward people that are managing someone else's calendar. Plus I don't _think_ it meets the criteria of actually booking the time off on the other calendar. Either way, it looks kind of cumbersome to set up and to manage.

### Spike

I didn't give this much more than a glance. It does _way_ more than I want it to and calendar sync doesn't appear to be among their more popular features. In any case, the banner says "email and chat app" and the byline talks about teams and partners. I don't think I'm their target audience.

### Reclaim.ai

Also has many features I don't need nor want though at least it's focused on calendars. Google Calendar specifically. Outlook is coming soon. So while calendar sync is one of the highlighted features, the lack of Outlook, as well as the focus on collaboration and AI and "smart" also suggests it's overkill.

### Calendly

I've used Calendly before to send people links to schedule calls with me. It's a lovely app and the free version is quite powerful. I'd recommend it even over Google Calendar's built-in "scheduling slots" or "appointment schedules" or whatever they're calling the feature now.

That said, based on what I read, I don't think they offer what I need. It looks like the paid plans will let you connect to multiple calendars so that you can give someone a link with a more comprehensive view of your availability. But I need something for internal people who have direct access to my calendar.

### Fantastical

This is just plain a gorgeous app, if you'll forgive an awkwardly-worded almost-oxymoron. I keep threatening to use it every couple of years but can't really justify it. The major selling points are syncing across multiple devices, the natural language parsing, the UX, and integration with a lot of other productivity tools I don't use. Seriously, you should check this app out...

...except if all you need is to sync events across multiple calendars. I'm still in the midst of testing the app but the process to ensure an event appears as a block of unavailable time on multiple calendars seems to be to duplicate it. Which, to be fair, they make _really_ easy. And if you keep the details the same in all the clones, the unified calendar view removes the duplicates. But that doesn't meet criteria #2 for me above. And if you change the name, it shows as a separate event which is a bit clumsy. For this feature specifically, it's not much better than what I can achieve in Google Calendar natively. But still, give it a whirl.

### Final verdict: OneCal (CalendarBridge runner up)

That leaves two options: OneCal and CalendarBridge. Both do the same thing though their respective marketing teams might squabble over technicalities. Their primary purpose is to sync multiple calendars and avoid double-bookings. Perfect.

Both services sync one calendar to another by cloning events between them and monitoring the source calendar for new events. Both give you control over what information you want to copy over and have similar options like excluding events of a given colour or excluding events where you're marked free (useful if you track birthdays in your calendar). Once syncing was set up, my calendars looked pretty much exactly how they did when I was doing it manually.

Neither service has a mobile app from what I can tell which is a shame, especially in the case of OneCal because unlike CalendarBridge, they offer a unified calendar view of all your calendars with the option to hide the cloned events. This is a nice touch and while the view is mobile friendly, it's missing some features, like a three-day view or the ability to put a widget on your phone.

Pricing is virtually identical on both services in that the one I would need runs about $100/year to sync three calendars. OneCal has the ability to do two-way syncs between calendars or to broadcast a one-way sync from one calendar to multiple other calendars, something that I don't _think_ CalendarBridge does. In CalendarBridge, a two-way sync is done with two one-way syncs and their pricing reflects that. The basic plan for both essentially covers two calendars so I'd be looking at premium for both.

Setting up the syncs seemed nicer in OneCal to me though I can't 100% say why. Both essentially walk you through a three-ish-step wizard to do it. Maybe OneCal worded things better or laid things out more intuitively for me. I found myself wondering if I was doing it right a couple of times in CalendarBridge. OneCal also felt zippier in general.

Both apps give you booking links (a la Calendly) which is nice if you need that. OneCal apparently integrates with Zoom to automatically add a meeting link to appointments booked online but I didn't test that out since I don't need it. Neither requires a credit card to sign up which is an underrated feature these days.

A couple of little UX things. First, OneCal has another underrated feature: a big ol' Delete My Account button at the bottom of the settings page. This is great for someone who wants to test things out, decide it's not for them, and move on. I'm not planning to use CalendarBridge and I've cancelled my free trial but the account remains. There's no obvious way to delete it so I guess I'm a CalendarBridge user indefinitely now. I suppose that's good for them to pump up their user numbers in case someone wants to buy them out but doesn't do me any good.

Second thing is CalendarBridge's login mechanism. To log in, I enter my email address, they email me a code, I enter the code. It's basically the standard 2FA mechanism from fifteen years ago. There's no password, no Google/Apple/Facebook/etc option. It's kinda weird. Like the developers have a personal agenda against traditional authentication and this is their manifesto.

So both apps do what I want and cost roughly the same but I give the edge to OneCal for their usability and their unified Calendar view. The price point is high enough that I'll give it a few days before pulling the trigger so I can decide if I want this more than I want to watch seasons 2 of Silo and Severance.

The alternative is to set up an auto-decline automation for all meetings which I haven't fully taken off the table yet.
