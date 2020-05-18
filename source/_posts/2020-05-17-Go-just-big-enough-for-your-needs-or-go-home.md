---
layout: post
title: Go just big enough for your needs or go home
tags:
  - bash
  - XML
  - XSLT
categories:
  - bash
date: 2020-05-18 15:42:18
authorId: kyle_baley
---

I love crossword puzzles. This post is only peripherally about crosswords specifically but I say it up front to filter my readership to those who might have a personal kinship with me and thus, are less likely to write angry comments.

<!-- more -->

For the longest time, the most commonly-used app on my phone by at least an order of magnitude was [Crosswords Classic](https://apps.apple.com/us/app/crosswords-classic/id284036524) by Stand Alone, Inc. (They have a newer version that's probably better but every time I've tried it, there's a "who moved my cheese" factor I've never really cared to overcome.) When I had an Android device, it was [Shortyz Crosswords](https://play.google.com/store/apps/details?id=com.totsp.crossword.shortyz&hl=en). Both excellent and both worth whatever price I paid for them (I've long forgotten).

However, in my advancing years, I've taken to the printed page more and more and in the last year or so, I've been printing crosswords and doing them in pen and paper instead. This was a good move for two reasons: 1) My screen time dropped by more than half, and 2) it opened up several crossword providers that, to my knowledge, aren't available in the apps. For reasons unknown to me, many crossword providers are not making their work available to these apps (e.g. USA Today, Washington Post, and New York Times). In fact, several of them have set up their own payment systems to subscribe to them (e.g. American Values, Matt Gaffney, Elizabeth Gorski).

The upside is that now I have a whole new world of crosswords in an arguably more leisure form. The downside is why you're reading this post: now I have to hunt and peck my way through half a dozen providers, using different delivery mechanisms, rather than have an app just go out and get them. My workflow for this used to be:

1) As emails come in from email providers, save the PDFs in a special folder
2) For others:
    - Navigate to the website
    - Navigate to each day
    - Download the PDF
3) Once I have everything collected, merge the crosswords into a single PDF and print
4) Archive the ones I merged
5) Repeat when I run out of crosswords

> Fun fact: Step 3 isn't as onerous as you might think. I spent a good half hour building an Automator action in MacOS to do this until I found out the functionality is built into the right-click menu.

As you can imagine, this virtually reeks of needing automation. So being a good developer, I designed in my head a system that would meet my needs:

- An ASP.NET Core-based app with a React front-end
- Authentication with multiple providers (Google, Facebook, etc.)
- Azure storage to store the PDFs
- Azure Logic Apps to parse emails that I send to a special address
- Azure function triggered nightly to download from non-email providers
- Some (hopefully free) PDF library to merge the PDFs
- A utility to parse XML into an image to be exported as a PDF

(That last one is mostly for USA Today but basically any puzzle provided by uclick.com. They have a special XML format that describes crosswords.)

> Let's ignore the cost-benefit of building all this vs. the 10 minutes each week I spend on it manually and chalk it up to: because it's there

I'll skip ahead a bit so I can get to my point. I was a couple of days into this when I remembered [a Reddit post](https://www.reddit.com/r/crossword/comments/dqtnca/my_automatic_nyt_crossword_downloading_script/) I had read recently where someone had automated the download of New York Times crosswords (provided you had a subscription, of course) using a bash script. Then it occurred to me: Do I _need_ all this infrastructure? Azure storage, hosting, logic apps, functions? Could I expand on this bash script from this random, helpful stranger instead?

Skipping ahead a bit further and the answers are, of course: [no I don't, and yes I can](https://github.com/kbaley/xword-downloader). The new stack:

- bash
- Zapier
- Mailparser.io
- C# console app
- XML/XSLT/HTML/CSS Grid
- Google Chrome (headless)
- The built-in MacOS functionality I mentioned earlier

I'm using Zapier/Mailparser.io to handle the email providers, C#/XML/XSLT for the uclick providers to transform the XML into HTML (there's very little C#), Chrome to print that HTML to PDF, built-in MacOS to merge the PDFs, and bash to tie it all together. 

Here's my new workflow:

1) Run the bash script
2) Print
3) Solve
4) Repeat when I run out

... and the only reason I haven't automated #2 is because I haven't looked into the `lp` command yet and I like to spot-check the NYT puzzles before I print them.

Now all this is not polished by any definition of the word and it is highly customized to my environment. But by gum, it works. And it still gave me the same rush I've always felt when I've been working at something and it eventually works. Figuring out Zapier's and MailParser's rule systems, re-learning XSLT, seeing HTML files disappearing and working PDFs taking their place. Getting into the minutiae of something that should be easy (like URI-decoding text in XSLT 1.0) but isn't. Not to say, "How can I learn Azure?" but to break a problem down, find a tool, and execute until it works. This is the same routine I used almost 40 years ago when I thought to myself, "I wonder if I can make it say, 'TAKE THAT LOSERS!!!' whenever I score a touchdown" on the old ASCII-based football game in my dad's office computer they let me sit at while waiting for a dentist appointment.

It's likely I'll be the only one who uses this thing, and to be honest, I hope I am because the idea of supporting it gives me the shakes. My original design was certainly more ambitious and might be easier to turn into a conference talk. But it's overkill. Maybe there's a market for applications that collect and manage crossword puzzle PDFs; I'm past the point where I want to build an application that meets that need first and my personal need second.

Kyle the Unsolveable