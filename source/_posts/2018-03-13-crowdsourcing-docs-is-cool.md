---
layout: post
title: Crowdsourcing Documentation is Cool
tags:
  - JavaScript
  - Documentation
categories:
  - Development
authorId: david_wesst
date: 2018-03-13 09:40:00
---

The idea of these large enterprises crowdsourcing their technical documentation is pretty cool. More cool than I had originally realized, and I want to take a moment to explain why I like it and why you should get involved yourself.

<!-- more -->

[1]: https://i.imgur.com/5ptKftE.png
[2]: https://docs.microsoft.com/en-us/microsoft-edge/extensions/extensions-for-enterprise
[3]: https://github.com/awsdocs
[4]: https://github.com/MicrosoftDocs
[5]: https://github.com/mdn

I updated the Microsoft Edge documentation on web extensions. As of this writing, you can see it [here][2], but just in case you can't I've included an image.

![][1]

The idea of these large enterprises crowdsourcing their technical documentation is pretty cool. More cool than I had originally realized and, for that reason, I want to take a moment to explain why I like it and why you should get involved yourself.

## What do you mean by "Crowdsourcing"?
When it comes to web platforms, many of the platform owners ([Amazon][3], [Microsoft][4], [Mozilla][5]) have started crowdsourcing their technical documentation. When I say _crowdsourcing_ I mean that the organization opens up the conversation about what the documentation should say to the community at large.

The community, being the consumers of the product (and the documentation) can have input into adding, editing, or removing sections of official product or platform documentation. Assuming the vendor agrees with the changes being suggested, then the change is accepted and the official documentation is updated.

This whole process if facilitated generally by GitHub, where documentation is published as source code and pull requests act as the avenue submitting changes. This way, the conversation about the changes is tracked, shared, and kept in the open for people to review and understand.

Plus, using things like contributors guides and automated build tools can be integrated with GitHub to validate the change, to make sure that the change to the documentation doesn't break anything and follows any rules the vendor has in place.

## Where is the coolness?
There are a couple of cool points I'd like to highlight.

### Consumers are More Qualified than Vendors
The developers of the platform itself are somewhat qualified considering they know the inner workings of the product, but they aren't the ones using it. The people using the product don't need to know how the guts work, they need to how to use it.

There is nobody more qualified to update product documentation than the consumers of the documentation and technology. The people that are neck deep and actually _using_ in tech to make things happen. Those are the people that are best suited to critique and ultimately improve the documentation.

### Transparent Conversations
When you crowdsource your documentation, you need to make it open and accessible, which tends to make conversation around the documentation transparent. In our case, GitHub provides the facilty to make this happen with public repositories filled with documentation and through the issue and pull request interface.

People can submit pull requests and issues and have a conversation with the vendor about their documentation and ultimately their product.

Something that starts out like a minor update, could result in an entire section. In my case, I was confident that I'd be adding new pages of content, but once I got into the thick of it, I realized all the parts were already present in the docs. I just needed to add some context and minor updates to what was already there.

## Conclusion
In conclusion, anyone reviewing the documentation for a tool or technology should check to see if:

1. It's open to improvement through crowdsourcing
2. They can think they can make it better.

It's a great way to get involved in your technology community, all while improving the developer experience for the next person that comes along.