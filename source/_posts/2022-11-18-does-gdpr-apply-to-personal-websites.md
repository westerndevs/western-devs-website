---
title: Does GDPR Apply to Personal Websites?
date: 2022-11-18T20:10:07.083Z
tags:
  - gdpr
  - ldgp
  - ccpa
  - privacy
  - cookies
  - website
originalurl: https://www.davidwesst.com/blog/does-gdpr-apply-to-personal-websites
authorId: david_wesst
excerpt: While rebuilding my personal website in 2022, I wanted to know how or
  if GDPR applied to my little side project. My internet sleuthing did not bring
  up any clear and cut answers, but I put together some thoughts that might help
  others answer it for themselves.
---

[1]: https://gdpr.eu/cookies/
[2]: https://github.com/davidwesst/website/releases/tag/v10.0.1
[3]: https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview
[4]: https://leginfo.legislature.ca.gov/faces/billTextClient.xhtml?bill_id=201720180AB375
[5]: https://iapp.org/media/pdf/resource_center/Brazilian_General_Data_Protection_Law.pdf
[6]: https://www.priv.gc.ca/en/privacy-topics/privacy-laws-in-canada/the-personal-information-protection-and-electronic-documents-act-pipeda
[7]: https://gdpr.eu/eu-gdpr-personal-data/
[8]: https://techstory.in/eu-declares-google-analytics-illegal-heres-why/
[9]: https://learn.microsoft.com/en-us/azure/azure-monitor/app/data-retention-privacy
[10]: https://learn.microsoft.com/en-us/azure/azure-monitor/app/javascript?tabs=snippet#cookie-handling
[11]: https://www.davidwesst.com/about
[12]: https://gdpr.eu/compliance/
[13]: https://gdpr.eu/

A few weeks back, I [released v10.0.1 of my website][2]. I use a static site generator to generate all the pages and publish it out into the internet for all the world to read. In that release, I added [Application Insights][3] to provide me with some performance data, but also to get a bit of usage data (for those willing to share it).

What I found odd was that all the links and articles I came across seemed to talk about things at a high-level (i.e. defining GDPR) or assumed I was working at a large scale (i.e. enterprise software), but nothing small projects like my personal website.

Still, I managed to draw some of my own conclusions on how to handle GDPR for my personal website and wanted to document them somewhere.

## DISCLAIMER: This is not legal advice

I am not a lawyer, so this is just an opinion from a developer. As a rule of thumb, I avoid taking legal advice from random folks on the internet. If you take advice from this article, take that bit and keep it. 

I hope others (like you) use this post to draw your own conclusions or how you want to proceed with your own plan for handling GDPR.

But if you want _real_ advice. Get a lawyer and talk to them.

## Short Answer: Yes

Yes, it does apply to your personal website **if** are tracking information about your users **and** you are developing your own website or application.

### Developing Your Own Website or Application

I mean developing as it coding it, publishing that code, and hosting it somewhere like Microsoft Azure or GitHub Pages. If you are publishing your own code, GDPR may apply to you.

If you are using a third party tool or platform, like Facebook or LinkedIn to host your blog posts-- you appear to be in the clear. When you use a third-party platform, the _platform_, not you, is responsible for GDPR compliance.

Even if you think you are clear of GDPR responsibility, make sure that you trust your chosen platform to comply to GDPR and other regulatory bodies out there, as your site depends on it. 

### Tracking Information

The GDPR is all about protecting personal information and giving control back to people navigating the internet. GDPR is not the only set of laws in play, as [California][4], [Brazil][5], and [Canada][6] have their own versions of similar legislation, but many of these laws seem to have been inspired by GDPR and why I tend to focus on it.

At the personal website level, you need to consider whether or not you are collecting personal information from your users. This includes things like [IP addresses or cookie identifiers][7].

If you are NOT collecting information like that, you are good to go! Just remember that services like Google Analytics or Disqus Comments use personally identifiable information to operate, so if you have decided to include one of those services on your site then you need to think about GDPR compliance.

## My Solution Highlights

I concluded the GDPR-like laws apply to my personal website if I want to do any kind of usage tracking and understand how users are using my site.. This means it needs to be an opt-in policy that gives the user the option to do just that, _opt-in_.

![A screenshot of the davidwesst.com blog page with a dialogue docked to the bottom with the statement: 'This site uses cookies to track usage in order to help improve the user experience. By clicking "Accept", you consent to our use of cookies.' along with gray 'Accept' and 'Decline' buttons, and a blue link with the text 'Privacy Statement'](/images/2022-11-18-does-gdpr-apply-to-personal-websites/my-gdpr-dialogue.png)

The dialogue above is the only real visual evidence on the site now. As simple as that looks, a lot of thought went into it prior to implementation. Rather than doing a complete code review, I figured I would share the highlights.

### Understanding My Tools

My default would just be to include something like Google Analytics, and be done with it, but with [GA being made illegal in the EU][8] and more countries creating their own GDPR-like legislation, I thought I would stay away from it and try something different.

I chose [Application Insights][3] and took the time to learn how [it handles data privacy and retention][9] and how the [JavaScript SDK uses cookies][10].

Regardless of what you choose for your analytics or tracking tool, the important part is that you understand how the tools are GDPR compliant and how the tracking technology works.

### Opt-In for Cookies

You've seen million of them already, but those cookie banners have purpose. The [GDPR website outlines the requirements][1] around using cookies, and many tools use them. The important thing is that _you_ know how your website works, along with all the dependencies _you choose_ to include.

In my case, the cookie banner enables cookies in Application Insights, which in turn enable usage data collection, only if they click "Accept". 

### Transparency

This last point is less technical, and more about design. I am designing with transparency in the front of my mind. I added a [privacy statement to my about page][11] to explain the "why" around using Application Insights, and will share more specifics and document them accordingly.

## Conclusion / TL;DR;

GDPR and the various GDPR-like laws definitely apply to you and your personal website or app project if you are building the code yourself, assuming you want to track information about your users.

The short story on this is that you need to draw your own conclusions and take responsibility for what you include in your website. If you are developing something to share outward into the world, you need to take the time to understand how the various tools you are included (such as Google Analytics or Application Insights) as well as the requirements for compliance. 

### GDPR Resources

Two resources I found useful in explaining GDPR requirements are provided on the site [GDPR.eu][13]. If you are looking for more information, I definitely suggest checking out these links:

- [Cookies, the GDPR, and the ePrivacy Directive][1]
- [Everything you need to know about GDPR compliance][12]

Thanks for playing.

~ DW
