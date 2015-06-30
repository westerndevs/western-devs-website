---
layout: post
title:  "On UI Testing"
date: 2015-06-30 20:09:05
author: kyle_baley 
originalurl: http://kyle.baley.org/2015/06/on-ui-testing/
categories:
excerpt: What happens when 12 people gather to talk about UI testing?
---

A short while ago, a group of [Devs of the Western variety](http://www.westerndevs.com) had a chat. It was the latest in a series, depending on how you define "series", where we gather together to discuss some topic, be it JavaScript frameworks, OO practices, or smoked meat. On this particular day, it was UI testing.

I don't recall all the participants but it was a good number of the people on [this list](http://www.westerndevs.com/about/). Here, I'm going to attempt to summarize the salient points but given my memory, it'll more likely be a dissertation of my own thoughts. Which is just as well as I recall doing more talking than I should have.

### Should you UI test?

This was a common thread throughout. Anyone who has done a significant amount of UI testing has asked a variant of this question. Usually in the form, "Why the &*%$ am I doing this?"

Let it not be said that UI testing is a "set it and forget it" affair. Computers are finicky things, UI's seemingly more so. Sometimes things can take just that one extra second to render and all of a sudden your test starts acting out a Woody Allen scene: Where's the button? There's supposed to be a button. YOU TOLD ME THERE WOULD BE A BUTTON!!!

Eventually, we more or less agreed that they are _probably_ worth the pain. From my own experience, working on a small team with no QA department, they saved us on several occasions. Yes, there are the obvious cases where they catch a potential bug. But there was also a time when we had to re-write a large section of functionality with no change to the UI. I felt _really_ good about having the tests then.

One counter-argument was whether you could just have a comprehensive suite of integration tests. But there's something to be said for having a test that:

1) Searches for a product
2) Adds it to the shopping cart
3) Browses more products
4) Checks out
5) Goes to PayPal and pays
6) Verifies that you got an email

This kind of integration test is hard to do, especially when you want to verify all the little UI things in between, like whether a success message showed up or whether the number of items in the shopping cart incremented by 1.

We also had the opposite debate: If you have a comprehensive suite of UI tests and are practicing BDD, do you still need TDD and unit tests? That was an interesting side discussion that warrants a separate post.

### Maintenance

...is ongoing. There's no getting around that. No matter how bullet-proof you make your tests, the real world will always get in the way. Especially if you integrate with third-party services (&lt;cough&gt;PayPal&lt;cough&gt;). If you plan to introduce UI tests, know that your tests will be needy at times. They'll fail for reasons unknown for several consecutive runs, then mysteriously pass again. They'll fail only at certain times of the day, when Daylight Savings Time kicks in, or only on days when Taylor Swift is playing an outdoor venue in the western hemisphere. There will be no rhyme or reason to the failures and you will never, _ever_ be able to reproduce them locally.

You'll add `sleep` calls out of frustration and check in with only a vague hope that it will work. Your pull requests will be riddled with variations of "I swear I wouldn't normally do this" and "I HAVE NO IDEA WHAT'S GOING ON". You'll replace elegant CSS selectors with XPath so grotesque that Alan Turing will rise from his grave only to have his rotting eyeballs burst into flames at the sight of it.

This doesn't really jibe with the "probably worth it" statement earlier. It depends on how often you have to revisit them and how much effort goes into it. From my experience, early on the answer to that is often and a lot. As you learn the tricks, it dwindles significantly.

One of those tricks is the [PageObject pattern](http://martinfowler.com/bliki/PageObject.html). There was universal agreement that it is required when dealing with UI tests. I'll admit I hadn't heard of the pattern before the discussion but at the risk of sounding condescending, it sounds more like common sense than an actual pattern. It's something that, even if you don't implement it right away, you'll move toward naturally as you work with your UI tests.

### Data setup

...is hard, too. At least in the .NET world. Tools like [Tarantino](https://github.com/HeadspringLabs/Tarantino) can help by creating scripts to prime and tear down a database. You can also create an endpoint (on a web app) that will clear and reset your database with known data.

The issue with these approaches is that the "known" data has to actually _be_ known when you're writing your tests. If you change anything in it, Odin knows what ramifications that will have.

You can mitigate this a little depending on your technology. If you use SpecFlow, then you may have direct access to the code necessary to prime your database. Otherwise, maybe you can create a utility or API endpoints that allow you to populate your data in a more transparent manner. This is the sort of thing that a ReST endpoint can probably do pretty well.

### Mobile

Consensus for UI testing on mobile devices is that it sucks more than that time after the family dinner when our cousin, Toothless Maggie, cornered---...umm... it's pretty bad...

We would love to be proven wrong but to our collective knowledge, there are no decent ways to test a mobile UI in an automated fashion. From what I gather, it's no picnic doing it in a manual fashion. Emulators are laughably bad. And there are more than a few different types and versions of mobile device so you have to use these laughably bad options about a dozen different ways.

### Outsourcing

What about companies that will run through all your test scripts on multiple browsers and multiple devices? You could save some development pain that way. But I personally wouldn't feel comfortable unless the test scripts were _extremely_ prescriptive. And if you're going to that length, you could argue that it's not a large effort to take those prescriptive steps and automate them.

That said, you might get some quick bang for your buck going this route. I've talked to a couple of them and they are always eager to help you. Some of them will even record their test sessions which I would consider a must-have if you decide to use a company for this.

### Tooling

I ain't gonna lie. I like Cucumber and [Capybara](https://github.com/jnicklas/capybara). I've tried [SpecFlow](http://www.specflow.org/) and it's probably as good as you can get in C#, which is decent enough. But it's hard to beat `fill_in 'Email', :with => 'hill@billy.edu'` for conciseness and readability. That said, do **not** underestimate the effort it takes to introduce Ruby to a .NET shop. There is a certain discipline required to maintain your tests and if everyone is scared to dive into your rakefile, you're already mixing stripes with plaid.

We also discussed [Canopy](http://lefthandedgoat.github.io/canopy/) and there was a general appreciation for how it looks though [Amir](/bios/amir_barylko) is the only one who has actually used it. Seems to balance the readability of Capybara with the "it's still .NET" aspect of companies that fear anything non-Microsoft.

Of course, there's Selenium both the IDE and the driver. We mentioned it mostly because you're supposed to.

Some version of Visual Studio also provided support for UI tests, both recorded and coded. The CodedUI tests are supposed to have a pretty nice fluent interface and we generally agreed that coded tests are the way to go instead of recorded ones (as if that were ever in doubt).

Ed. note: Shout out to [Protractor](https://angular.github.io/protractor/#/) as well. We didn’t discuss it directly but as [Dave Paquette](http://www.westerndevs.com/bios/dave_paquette/) pointed out later, it helps avoid random Sleep calls in your tests because it knows how to wait until binding is done. Downside is that it’s specific to Angular.

Also: [jasmine](http://jasmine.github.io/) and [PhantomJS](http://phantomjs.org/) got passing mentions, both favorable.

### Continuous Integration

This is about as close as we got to disagreement. There was a claim that UI tests shouldn't be included in CI due to the length of time it takes to run them. Or if they are included, run them on a schedule (i.e. once a night) rather than on every "check in" (by which we mean, every feature).

To me, this is a question of money. If you have a single server and a single build agent, this is probably a valid argument. But if you want to get full value from your UI tests, get a second agent (preferably more) and run only the UI tests on it. If it's not interfering with your main build, it can run as often as you like. Yes, you may not get the feedback right away but you get it sooner than if you run the UI tests on a schedule.

***

The main takeaway we drew from the discussion, which you may have gleaned from this summary, is: damn, we should have recorded this. That's a mistake we hope to rectify for future discussions.