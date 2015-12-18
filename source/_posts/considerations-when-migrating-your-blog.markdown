---
layout: post
title: "Considerations When Migrating Your Blog"
date: 2015-08-01 16:15:22
categories:
comments: true
authorId: david_wesst
originalurl: http://blog.davidwesst.com/2015/07/Considerations-When-Migrating-Your-Blog/
---

I'm talking about small-scale, personal blogs or projects.

The word "enterprise" isn't used once to describe any part of the project, yet there are plenty of things I had to consider (or decide along the way) before I completed the migration. Eventually, I ended moving my [Ghost](http://ghost.org) blog to a [Hexo](http://hexo.io)-based static blog, that is hosted on [Github Pages](https://pages.github.com) under a new subdomain.

<!--more-->

Before I actually did any of the work, I answered a handful of questions which helped guide me through the migration and ultimately feel much more comfortable with the result.

Think of this post as a checklist with a sample reflection on answering each question. Hopefully it helps guide you as it did me.

The questions I asked were:

1. <a href="#whatisthepoint">What is the Point of your Blog/Site?</a>
2. <a href="#whydoyouwanttomigrate">Why do you want to Migrate?</a>
3. <a href="#whatdoyouneedfromahost">What do you need from a Host?</a>
4. <a href="#existingreaders">How will your existing readers find your migrated content?</a>
5. <a href="#whatisallthecontent">What is "All the Content"?</a>

![](http://blog.davidwesst.com/2015/07/Considerations-When-Migrating-Your-Blog/ghost-to-hexo.png)

## 1. What is the Point of your Blog/Site? <a id="whatisthepoint">#</a>
This question is something you probably asked yourself when you first setup your blog, site, or whatever. Now that you're considering migrating it to a new technology, you should revisit why it even exists. 

The great part about this is that there isn't a wrong answer, as long as there _is an answer_.

When I'm thinking about code, tech, and the what-not, I tend to skip the whole requirements gathering part of the work. Considering most of my career has revolved around defining requirements and designing user experiences to not only capture those requirements, but to enhance a user's ability to engage the system, it's pretty lazy of me to skip it.

Here's the questions I asked myself before getting into the tech:
+ Who is the audience for my blog/site?
+ What is the definition of "content"? Blog posts, or is it more than that?
+ How do I intend on sharing content?
+ Outside of authoring it, what else do I want to do with my content?
+ Is there anything else outside of publishing content that I want to do with the blog/site?

I also asked the following questions, which have less to do with technical requirements and more to do with resource availability (for myself):
+ How much time do I have to author content?
+ How much time do I have to update application and/or server itself?
+ Where do I actually spend time authoring content?

### Result
This was probably the hardest part for me. Because I like tinkering with new technology in my off time, I like spending time on that rather than worrying about requirements and the softer parts of my projects. Ultimately, I answered the questions, which really got me thinking about what my goals were for having a personal website and/or blog.

The purpose of the blog is to publish thoughts and content from me to my audience, and provide the ability for the audience to comment. My website _could_ be the same thing, but I've always had a vision that it would be more than a blog. Given, I'm not sure what that something is, I want to keep that door open for future ideas and thus I have two applications: a blog and a website.

## 2. Why do you want to Migrate? <a id="whydoyouwanttomigrate">#</a>
It sounds like an obvious question, but I tend to forget to ask this before any personal project. There really isn't a wrong answer considering that you're your own client, but you _should_ be able answer the question. If not, then you should keep on keepin' on with what you have, and decicate your time something more meaningful. 

In my case, I had a few reasons. I wanted to...
+ ...save my posts as markdown files to make cross posting easier
+ ...to not have to maintain or upgrade the engine or server hosting the blog ever again
+ ...move my blog to the _blog_ subdomain
+ ...~~setup~~ fix the permalinks so they contain the date in the URL
+ ...make my blogging experience more "hackable" to keep me practicing and experimenting with new coding tools

Your reasons will likely differ. That's fine. It's important to know _why_ you're doing all the work.

### Result
Answering this helped guide me on selecting my blogging technology along with my host provider. More specifically, to let go of [Ghost on Azure](https://github.com/felixrieseberg/Ghost-Azure) and move to [Hexo](http://hexo.io) to generate the content and host it for on [Github Pages](https://pages.github.com) to start.

## 3. What do you need from a Host? <a id="whatdoyouneedfromahost">#</a>

![](http://blog.davidwesst.com/2015/07/Considerations-When-Migrating-Your-Blog/host-thoughts.png)

It ties into the first question, but it's more specific to the features you need from a hosting provider. The features of your host will have an impact on what you can accomplish with your site migration and depending on the technologies you want to use, the host may have some specific ways you need to implement them. For example, if you're considering using something like WordPress, the hosting provider may provide you with a "standard install image" rather than having to setup the application from scratch.

In my case, I only needed the ability to host static files and to use a custom domain. I wanted an easy way to deploy, ideally so I can automate the whole thing at some point, but that was a secondary consideration.

### Result
I like Windows Azure as a hosting provider as it makes me feel safe and in control of my blog. 

That being said, it was overkill for the amount of traffic I'm getting and how much I'm using it. I don't need things like HTTPS or an online blog editor. I just needed a place to put the generated static files. My host selection was [Github Page](https://pages.github.com) for the blog, and continuing to use a cheap Windows Azure site to handle the redirects.

If I outgrow my Github Pages site and need something with support and more control, then I'll move it back over to Windows Azure or [Surge](http://surge.sh) which [I talked about a while ago on YouTube](https://youtu.be/DsLu3K65J5w?list=PLbTA1UhK0wKjBJyqzA3aDrxcv9NdD1V8c).

## 4. How will your existing readers find your migrated content? <a id="existingreaders">#</a>
If you've worked on production web sites or applications, this is something you've likely asked your client. Being my own client, in this case, I have skipped this step a few times. Why? Well, I tell myself that my blog traffic is pretty small, so it's too much work for such a small group of users, or something along those lines.

This time I realized that not only is that a total cop-out, but it's an ass thing to do to your audience. If people are willing to read, share, or talk about any of your blog content, appreciate them and make sure that if or when they decide to share your content again, your laziness doesn't make them lose street cred because they link they bookmarked on your blog no longer works.

### Result
My blog was hosted at [http://davidwesst.com](http://davidwesst.com) on Windows Azure. This meant I needed to find a way to redirect people to the appropriate post on the new [blog.davidwesst.com](http://blog.davidwesst.com). After taking stock of all of my blog content, I setup new NodeJS application with a web.config file on Windows Azure that contains all the mappings.

You can find the file here on my [GitHub Project](https://github.com/davidwesst/dw-website/blob/master/web.config), and a [tutorial URL Redirects and Rewrites on IIS.net](http://www.iis.net/learn/extensions/url-rewrite-module/creating-rewrite-rules-for-the-url-rewrite-module).

## 5. What is "All the Content"? <a id="whatisallthecontent">#</a>
Again, sounds like an obvious question, but it can be deceptive. 

A web site, even a personal one, is a bunch of hosted content. Pages, media, and the links between them. If you're using a content management system (CMS) to host your blog, then it has been taking care of all the logistics of linking your pages to your media files. Not only to do you need to figure out where those media files are so you can move them to your new application, you need to figure out how to possibly update references to those images.

Nothing overly complicated, but depending on how much time you have to spend on migrating and verifying your content, it can get overwhelming very quickly, especially if you have years of content saved up.

### Result
I did a bunch of reseach on tooling that could help make this possible. Being that Ghost is a pretty new blog engine, the migration features are still a bit raw. Hexo, on the otherhand, has plenty of tools and have some pretty flexible [migration options](https://hexo.io/docs/migration.html). Again, since Ghost is so new, nobody has written a migrator for it yet, although I doubt it would be very difficult.

Even then, because of my time limitations, I took the more manual route root and used the [rss-migrator](https://hexo.io/docs/migration.html#RSS) along with the [image-migrator](https://github.com/akfish/hexo-migrator-image) to get the content moved into Hexo. Then I updated the URLs with some regular expression magic in [Visual Studio Code](https://code.visualstudio.com).

I cheaped out on coding and just manually tested each post, but it worked with my schedule of just getting random late night hours at home to ensure the content moved properly.

# The Point
Whether you call the project _small_, _personal_, or _internal_, it takes some actual thought to make sure you do it right.

With smaller projects, whether they are for yourself or for your company, it's easy to take shortcuts. The challenge is that for every shortcut you take, you end up living with it in the long run. In my case, I would constantly ignore the permalink redirection, which means I'm resetting my audience every single time.

On top of that, I wanted my blog to possibly be a portfolio piece for myself. If I take shortcuts and end up ashamed of the quality of work, I'm losing some of the value of my labour.

Time is valuable, and I hope that this list reminds me and others, that if you're going to take the time to make something better, put your back into it.

You can see the result of my planning by looking at the two Github repositories, one for the [blog](https://github.com/davidwesst/dw-blog) and one for the [web site](https://github.com/davidwesst/dw-website) that doesn't do anything other than redirect people to the blog.

--
Thanks for playing. ~ DW

