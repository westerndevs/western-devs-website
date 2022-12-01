---
title: Open Graph Tools and Resources for Web Nerds (Like Me)
date: 2022-12-01T04:18:34.509Z
tags:
  - open graph
  - web development
  - seo
  - linkedin
  - facebook
  - twitter
originalurl: https://www.davidwesst.com/blog/open-graph-tools-and-resources-for-web-nerds
authorId: david_wesst
excerpt: A compilation of tools and resources I used to implemented the Open
  Graph Protocol (OGP) for my website to make posts and pages more engaging on
  LinkedIn and other social networks.
---

[1]: https://ogp.me
[2]: https://github.com/davidwesst/website/releases
[3]: https://chrome.google.com/webstore/detail/social-share-preview/ggnikicjfklimmffbkhknndafpdlabib
[4]: https://addons.mozilla.org/en-US/firefox/addon/social-share-preview/
[5]: https://www.linkedin.com/post-inspector/
[6]: https://developers.facebook.com/tools/debug/

The [Open Graph Protocol (OGP)][1] is an open standard that allows web pages to have deeper integration with a social graph, such as Facebook, Twitter, or LinkedIn. You know those cards that appear on Twitter or LinkedIn with tailored images for a link to a blog post? That is OGP in action.

With [my recent adventures with reimplementing my website][2], I wanted to leverage this on pages and posts, specifically with LinkedIn and it took a little more research to get it working right. So, for the web nerds like me looking to implement OGP on their projects, I wanted to share the resources I found useful to hopefully save them some time in finding the right resources.

## [`ogp.me`][1]

I am calling this the specification, or "spec", and it probably the most important resource. The best part about this site is how approachable it is. 

There are code snippets, explanations of all the object types and their properties, and its own list of tools (although they differ from the ones I am including on this list).

If you take one thing away from this post for your work with OGP, take this one.

### Reference

- [Open Graph protocol page][1]

## LinkedIn (and Facebook) Post Inspectors

Both Facebook and LinkedIn provide a developer tool to analyze and verify your implemenation of OGP and has the added feature of busting whatever the social networks have cached for the pages you share. 

These tools for triaging or assesing publically shared pages, but not so much when it comes to local development. That is where the next tool comes into play.

### Reference

- [LinkedIn Post Inspector][5]
- [Facebook Sharing Debugger][6]

## Social Share Preview Web Extension

Available for both [Chromium Browsers][3] and [Firefox][4], this web extension allows you simulate what should appears for any page loaded up in your browser.

This tool saved me from having to continually publish the content to a public location for the post inspector, but note that it is just a _simulation_ of what the tool thinks it should appear. It does not replace post inspector or proper testing on the site you are looking to share to.

![A window displaying a preview of what a LinkedIn post of the 'How much is enough documentation?' blog post on davidwesst.com](/images/2022-11-30-open-graph-tools-and-resources-for-web-nerds/social-share-preview-example.png)

### Reference

- [Chrome Extension][3]
- [Firefox Add-On][4]

## Browser Dev Tools (Obviously)

If you are reading the post, then this one is an obvious one-- but sometimes we (like me) get so caught up on exploring new ways to solve my problem, we forget about the obvious ones.

OGP tags live in the `<head>` of your HTML page. If you are unsure why things are not working, make sure you run your browser dev tools of choice and check the `<head>` of the document and make sure the OGP tags you are expecting appear where they should be.

It seems simple, but depending on what tool, engine, or framework to output HTML, you may be surprised what shows up.

### Reference

Open this post on a desktop browser and press the key combination `Ctrl + Shift + i` and you should see your browser dev tools pop open for the site.

## Conclusion / TL;DR;

Read the [aproachable spec document][1]. That is the most important part takeaway from my OGP implemenation. It is very approachable and gives you a strong foundation to work from as you use other tools to triage and assess your implementation.

These are the tools I used to implement LinkedIn support, along with my browser dev tools. 

- [LinkedIn Post Inspector][5]
- [Facebook Sharing Debugger][6]
- [Chrome Extension][3]
- [Firefox Add-On][4]
- `Ctrl + Shift + i` on your desktop browser

Thanks for playing.

~ DW

