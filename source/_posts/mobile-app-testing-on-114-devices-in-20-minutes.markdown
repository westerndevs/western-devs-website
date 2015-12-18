---
layout: post
title:  "Mobile App Testing on 114 Devices in 20 Minutes"
date: 2015-11-02T16:52:05-05:00
comments: true
authorId: lori_lalonde
originalurl: http://solola.ca/mobile-app-testing-xamarin-test-cloud/
alias: /mobile-app-testing-on-114-devices-in-20-minutes/
---

My day started off just like any other at the office. I plugged in my machine, launched Visual Studio and opened up the latest Xamarin.Android project I had been working on for the client. On this particular day, I had to make a layout change to ensure that the weighting of two different layouts were updated based on a set of conditions. Sounds easy enough, right?

<!--more-->
  
Well making the change was trivial. Next came the part that I dreaded, which I knew would take up the rest of my day. I walked over to the device cabinet, and grabbed a handful of devices varying in screen size, resolution and OS versions.

Seated at my desk, I attempted to power on the first device. Battery drain. I plugged it in, then attempted to power on the next device. Same thing. By the time I was able to get enough charge on a device to power it on, deploy to that device, and run through the necessary tests, 10 – 15 minutes had passed.&nbsp; Note that I have to repeat this process on 4 more devices. If the tests all pass the first time, that's about an hour of testing spent on a small fraction of devices for a single UI change. During my round of testing on the 4th device, I already noticed problems with the layout. This is going to be a really long day.

Even if all of my tests pass, QA will perform these tests on another set of devices at random which may uncover other issues. Even worse, what happens if the QA tests passed, and the application made it to market because there were issues on devices we hadn't covered? This wasn't the type of work I wanted to deliver. Ultimately, I want to be sure the layouts look good across as many devices as possible, including the most popular ones on the market.

Now what?

### A Better Way

Being out of office for the next week, I wanted to get this change completed to ensure it wouldn't hold the team up in my absence, and I wanted to feel confident that it would look good on a broad range of devices. I knew this would be an impossible feat if I stuck with the manual testing route. I decided to put&nbsp;[Xamarin Test Cloud][1]&nbsp;to use to make short work of this.

Thanks to those Xamarin University's courses on creating Xamarin UI Tests and deploying to Test Cloud – which I had already taken as a requirement for the&nbsp;Xamarin Mobile Developer Certification&nbsp;exam –&nbsp; I knew exactly how to get started. I also had some Test Cloud time to burn which comes with being a&nbsp;[Xamarin University][2]&nbsp;student – 25 hours to be exact.

I created a new&nbsp;[Xamarin UITest][3]&nbsp;project, and used&nbsp;[REPL][4]&nbsp;to assist with scripting out the steps. I copied the script into my UITest, and I included commands to take screenshots at specific points in the script. This process took about 10 minutes to complete and test on a local device.

Once I was confident that the UITest I had scripted performed as I expected, I decided to run it in Xamarin Test Cloud, simply by right-clicking on the UITest project in Visual Studio and selecting "Run in Test Cloud…" from the context menu. I was able to quickly and easily select 25 devices to run the test on, all of varying screen sizes, resolutions and OS versions. I was even able to select from devices that were most popular on the market, thanks to a filter provided within Xamarin Test Cloud.

![Xamarin Test Cloud Device Selection][5]

Within minutes, my test was deployed to the cloud, and 10 minutes later the test had been completed on all 25 devices. This consumed about 35 minutes of Xamarin Test Cloud device time usage (approx. 1.4 minutes per device). Based on the results, I had to tweak the layout and re-run the test two more times until the change looked good across the board, but this process was simple, fast and efficient. Now that I&nbsp;knew how fast it was to test on 25 devices, I decided to push it a little further. The next run was on 114&nbsp;devices. Twenty minutes later my changes were ready to review. Again, the total device time used averaged out to 1.4 minutes per device.

Reviewing the UI change across all&nbsp;devices was easy, because they were laid out on a single page in grid format. It was easy to scroll down the page and quickly point out any nuances which needed to be addressed. I could even filter and sort the view to quickly see the devices of interest.  

![XamarinTestCloudReviewTests][6]

_Test run results of the Xamarin Store Demo&nbsp;app_

What could have been 1 – 2 days of effort for a simple UI change, was completed in less than 2 hours, and I had covered more ground in those 2 hours than I ever would have in manual testing.

In addition to that, Xamarin Test Cloud provided metrics on the application's CPU and memory usage, as well as device and test logs. The history of all tests run are maintained in my account so I can go back to review them at any time.

### Lessons Learned

That was the scenario for the effort needed to test a simple UI change. Now compound that effort with a greenfield application, which requires the team to fully test each screen and feature on as many devices as possible. Expecting that a mobile development team and QA will be able to cover ground through manual device testing is pretty far-fetched. Not to mention the costs the company would have to absorb to continue to purchase new devices as they are released in order to be able to stay on top of a changing market.

Many companies balk at the&nbsp;[price][7]&nbsp;of Xamarin Test Cloud without considering how much money is being wasted on the current processes in place.

As the company's team continues to build out the organization's flagship mobile app and releases multiple versions, the QA Team becomes swamped and unable to test fast enough to cover ground on all those devices in that trusty cabinet. Developers barely have enough time in the schedule to fully develop the features needed, let alone allot the actual time needed to fully test across devices.

Eventually, the company considers hiring a new QA member to ease the work load. Do you think it is possible to hire someone into that role at $5/hour? No? Well, that's the cost of Xamarin Test Cloud – $5 per device hour when you break it down. Considering I was able to run a single UI test across 114&nbsp;devices using about 2.5 hours of device time, that would work out to be the best $12.50 ever spent. Not to mention, that's also 1 full day of developer time that is reclaimed to focus on the actual development of the product, rather than fiddling around with device after device to run manual UI tests. Last but not least, your QA team will be more focused on testing the application's functionality rather than being bogged down with logging UI related issues.

If you're still skeptical at how Xamarin Test Cloud can help accelerate your mobile app testing time, make use of the&nbsp;[free 60 minutes of Xamarin Test Cloud time][8]&nbsp;you're given each month with your&nbsp;Xamarin Platform Subscription.

### Final Thoughts

Spend a little, save a lot, and keep your mobile product team happy in the process.


[1]: https://developer.xamarin.com/guides/testcloud/introduction-to-test-cloud/
[2]: https://xamarin.com/university
[3]: https://developer.xamarin.com/guides/testcloud/uitest/
[4]: https://developer.xamarin.com/guides/testcloud/uitest/working-with/repl/
[5]: http://solola.ca/wp-content/uploads/2015/11/XamarinTestCloudDeviceSelection.png
[6]: http://solola.ca/wp-content/uploads/2015/11/XamarinTestCloudReviewTests.png
[7]: https://xamarin.com/test-cloud#pricing
[8]: https://blog.xamarin.com/xamarin-test-cloud-now-available-to-all-xamarin-developers/
  