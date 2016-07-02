---
title: O365 Custom Domains - Configuring It For A Website
layout: post
categories:
  - O365
  - Azure
authorId: darcy_lussier
date: 2016-06-20
---
Here's the situation - you've registered a custom domain and you've gone ahead and set it up to work with
Office 365 so you can have yourname@yourdomain.com for emails. Fantastic!

<!-- more -->

Now you've created a website and you'd like to use that same custom domain for it. That's whre I found myself tonight
and as you'll read below the process isn't as straightforward as you'd think.

I'm hosting my website in Azure, and the first step there is to set up a CNAME record on the domain. I logged in to
my registrar's website (where I purchsaed the domain) but it informed me that I'd have to point my domain DNS *back*
to theirs in order to make the change...which seemed silly. Or, they said, you can change it wherever I had moved the
domain to. In this case, it was to Microsoft's domain servers which I did when I set up Office 365.

So the question is...how do I now manage my domain when its hosted by Microsoft? Where is the domain administration tool?

The answer is...Office 365. Here's how you can access your domain's settings to add new entries like CNAME.

Step 1 - Log in to your Office 365 Administration portal, go down to Settings and select Domains.

![http://i.imgur.com/8E4aIG4.png](http://i.imgur.com/8E4aIG4.png)

Step 2 - Select the domain from the list that you want to add a setting to.

![http://i.imgur.com/bTxyHar.png](http://i.imgur.com/bTxyHar.png)

Step 3 - You'll be given three options. While DNS Management may seem like the likely stop, its not. Press the Check DNS
button instead.

![http://i.imgur.com/DsuXUrK.png](http://i.imgur.com/DsuXUrK.png)

Step 4 - The system will verify that "All DNS records are correct, no errors found" and will enable a DNS Settings area underneath.
Click it.

![http://i.imgur.com/VSeo2Yv.png](http://i.imgur.com/VSeo2Yv.png)

Step 5 - Under the DNS Settings options, expand the Custom Records and then click the New Custom Record button.

![http://i.imgur.com/4yW4SZg.png](http://i.imgur.com/4yW4SZg.png)

Step 6 - Now we can select the type of record we want to add. Fill it out and hit Save.

![http://i.imgur.com/OOS19NM.png](http://i.imgur.com/OOS19NM.png)

Step 7 - You'll now see a listing of the custom records entered for this domain.

![http://i.imgur.com/ZJeVxaf.png](http://i.imgur.com/ZJeVxaf.png)

In my case, just needed to set the CNAME up with the settings Microsoft Azure instructed me to, and do some final configuration
in the Azure portal to enable the custom domain for my website. You may have different instructions based on where you're hosting
your website at.

So just to recap: If you've set up a custom domain with Office 365, then you'll need to mangae your domain from the Office 365
administration console going forward and not yourr domain registrar.

Any questions or clarifications needed, please leave a comment!

Thanks,

D
