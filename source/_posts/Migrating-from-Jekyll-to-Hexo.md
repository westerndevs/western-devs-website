layout: post
title: "Migrating from Jekyll to Hexo"
date: 2015-12-18 14:00:42
categories: jekyll,hexo
comments: true
authorId: kyle_baley
---

WesternDevs has a shiny new look thanks to graphic designer extraodinaire, [Karen Chudobiak](http://www.karenchudobiak.ca/). When implementing the design, we also decided to switch from Jekyll to Hexo. Besides having the opportunity to learn NodeJS, the other main reason was Windows. Most of us use it as our primary machine and Jekyll doesn't officially support it. There are [instructions](http://jekyll-windows.juthilo.com/) available by people who were obviously more successful at it than we were. And there are even [simpler ones](https://davidburela.wordpress.com/2015/11/28/easily-install-jekyll-on-windows-with-3-command-prompt-entries-and-chocolatey/) that I discovered during the course of writing this post and that I wish existed three months ago.

<!--more-->

Regardless, here we are and it's already been a positive move overall, not least because the move to Node means more of us are available to help with the maintenance of the site. But it wasn't without it's challenges. So I'm going to outline the major ones we faced here in the hopes that it will help you make your decision more informed than ours was.

To preface this, note that I'm new to Node and in fact, this is my first real project with it. That said, I'm no expert in Ruby either, which is what Jekyll is written in. And the short version of my first impressions is: Jekyll feels more like a real product but I had an easier time customizing Hexo once I dug into it. Here's the longer version

## Documentation/Resources

You'll run into this very quickly. Documentation for Hexo is decent but incomplete. And once you start Googling, you'll discover many of the resources are in Chinese. I found very quickly that there is `posts` collection and that each post has a `categories` collection. But as to what these objects look like, I couldn't tell. They aren't arrays. And you can't `JSON.stringify` them because they have circular references in them. `util.inspect` works but it's not available everywhere.

## Multi-author support

By default, Hexo doesn't support multiple authors. Neither does Jekyll, mind you, but we found a [pretty complete](https://github.com/mmistakes/minimal-mistakes) theme that does. In Hexo, there's a [decent package](https://www.npmjs.com/package/hexo-multiauthor) that gets you partway there. It lets you specify an author ID on a post and it will attach a bunch of information to it. But you can't, for example, get a full list of authors to list on a Who We Are page. So we created a separate data file for the authors but we haven't figured out how to use that file to generate a .json file to use for the Featured section on the home page. So we have author information in three places. Our temporary solution is to disallow anyone from joining or leaving Western Devs.

## Customization

If you go with Hexo and choose an [existing themes](https://hexo.io/themes/), you won't run into the same issues we did. Out of the box, it has good support for posts, categories, pagination, even things like tags and aliases with the [right plugins](https://hexo.io/plugins/).

But we started from a design *and* were migrating from an existing site with existing URLs and had to make it work. I've mentioned the challenge of multiple authors already. Another one: maintaining our URLs. Most of our posts aren't categorized. In Jekyll, that means they show up at the root of the site. In Hexo, that's not possible. At least at the moment and I suspect this is a bug. We eventually had to fork Hexo itself to maintain our existing URLs.

Another challenge: excerpts. In Jekyll, excerpts work like this: Check the front matter for an `excerpt`. If one doesn't exist, take the first few characters from the post. In Hexo, excerpts are empty by default. If you add a `<!--more-->` tag in your post, everything before that is considered an excerpt. If you specify an `excerpt` in your front matter, it's ignored because there is already an `excerpt` property on your posts.

Luckily, there's a [plugin](https://github.com/lalunamel/hexo-front-matter-excerpt) to address the last point. But it still didn't address the issue of all our posts without an excerpt where we relied solely on the contents of the post.

So if you're looking to veer from the scripted path, be prepared. More on this later in the "good parts" section.

## Overall feeling of rawness

This is more a culmination of the previous issues. It just feels like Hexo is a work-in-progress whereas Jekyll feels more like a finished product. There's a strong community behind Jekyll and plenty of help. Hexo still has bugs that suggest it's just not used much in the wild. Like [rendering headers with links in them](https://github.com/hexojs/hexo-renderer-marked/issues/16). It makes the learning process a bit challenging because with Jekyll, if something didn't work, I'd think _I'm obviously doing something wrong_. With Hexo, it's _I might be doing something wrong or there might be a bug_.

## The good parts

I said earlier that the move to Hexo was positive overall and not just because I'm optimistic by nature. There are two key benefits we've gained just in the last two weeks.

### Generation time

Hexo is fast, plain and simple. Our old Jekyll site took six seconds to generate. Doesn't sound like much but when you're working on a feature or tweaking a post, then saving, then refreshing, then rinsing, then repeating, that six seconds adds up fast. In Hexo, a full site generation takes three seconds. But more importantly, it is smart enough to do incremental updates while you're working on it. So if you run `hexo server`, then see a mistake in your post, you can save it, and the change will be reflected almost instantly. To the point where it's usually done by the time I've switched back to the browser.

### Contributors

We had logistical challenges with Jekyll. To the point where we had two methods for Windows users that wanted to contribute (i.e. add a post). One involved a [Docker image](http://www.westerndevs.com/docker-and-western-devs/) and the other [Azure ARM](http://www.westerndevs.com/using-azure-arm-to-deploy-a-docker-container/). Neither was ideal as they took between seconds and minutes to refresh if you made changes. Granted, both methods furthered our collective knowledge in both Docker and Azure but they both kinda sucked for productivity.

That meant that realistically, only the Mac users really contributed to the maintenance of the site. And our Docker/Azure ARM processes were largely ignored as we would generally just test in production. I.e. create a post, check it in, wait for the site to deploy, make necessary changes, etc, etc.

With the switch to Hexo, we've had no fewer than five contributors to the site's maintenance already. Hexo just works on Windows. And on Mac. Best of both worlds.

### Customization

We've had to make some customizations for our site, including [forking Hexo](https://github.com/westerndevs/hexo) itself. And for me personally, once I got past the _why isn't this working the way I want?_ stage, it's been a ton of fun. It's crazy simple to muck around in the node modules to try stuff out. And just as simple to fork something and reference it in your project when the need arises. I mentioned an earlier issue rendering links in headers. No problem, we just swapped out the markdown renderer for [another one](https://github.com/celsomiranda/hexo-renderer-markdown-it). And if that doesn't work, we'll tweak something until it does.