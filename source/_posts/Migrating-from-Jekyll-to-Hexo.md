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

You'll run into this very quickly. Documentation for Hexo is decent but incomplete. And once you start Googling, you'll discover many of the resources on it are in Chinese. I found very quickly that there is `posts` collection and that each post has a `categories` collection. But as to what these objects look like, I couldn't tell. They aren't arrays which you'll find out quickly. And you can't `JSON.stringify` them because they have circular references in them. `util.inspect` works but it's not available everywhere.

## Multi-author support

By default, Hexo doesn't support multiple authors. Neither does Jekyll, mind you, but we found a [pretty complete](https://github.com/mmistakes/minimal-mistakes) theme that does. In Hexo, there's a [decent package](https://www.npmjs.com/package/hexo-multiauthor) that gets you partway there. It lets you specify an author ID on a post and it will attach a bunch of information to it. But you can't, for example, get a full list of authors to list on a Who We Are page. So we created a separate data file for the authors but we haven't figured out how to use that file to generate a .json file to use for the Featured section on the home page. So we have author information in three places. Our temporary solution is to disallow anyone from joining or leaving Western Devs.

## Customization

If you go with Hexo and choose an existing templates, you won't run into the same issues we did.