---
layout: post
title: 'Migrating from Jekyll to Hexo: Part 2'
categories:
  - jekyll
  - hexo
date: 2015-12-24 19:43:32
tags:
excerpt: Specific issues we ran into during the migration from Jekyll to Hexo
---

In my [previous post](http://www.westerndevs.com/jekyll/hexo/Migrating-from-Jekyll-to-Hexo/), I gave some general impressions from the recent conversion of WesternDevs from Jekyll to Hexo. Here, I'll outline specific issues we tackled during the process of migrating and converting to our own theme.

### Excerpts 

Jekyll and Hexo handle excerpts very differently. In Jekyll, you can specify an excerpt in the front matter. If one isn't provided, it will use the first few characters of the post itself as the excerpt.

In Hexo, the excerpt is set in one and only one way. You need to add `<!--more-->` somewhere in the post. Everything before that is considered the excerpt. If you don't have that tag in your post, no excerpt.

<div style="float: right; width: 250px; border: 1px solid #ddd; background-color: #eee; padding: 8px; font-size:12px; margin: 8px;">One minor annoyance with the default handling of the excerpt in Hexo is that it escapes HTML. So if you have a link in your excerpt, it shows as &lt;a href='moo.com'&gt;My web page&lt;/a&gt; in the excerpt. Our current solution is to make sure these posts have an explicit excerpt in the front-matter.</div>

Luckily, [Amir](http://www.westerndevs.com/bios/amir_barylko/) had some foresight and added code to our Jekyll site to support `<!--more-->`. Unluckily, we rarely used it. Some of our posts had excerpts, particularly the podcasts. But mostly, we relied on Jekyll to parse the post for the excerpt.

In the end, we did two things to remedy this. First we added the [https://github.com/lalunamel/hexo-front-matter-excerpt](hexo-front-matter-excerpt) package. This fixed all the posts that already had an `excerpt` in the front matter. For the rest, we went through all the remaining posts and added `<!--more-->` after the first paragraph. Ever the optimists, we also submitted a [pull request](https://github.com/lalunamel/hexo-front-matter-excerpt/pull/2) for the package to make it behave more like Jekyll.

### Syntax highlighting

A code block in Jekyll looks like this

```
{% highlight html %}
<div>moo</div>
{% endhighlight %}
```

And in Hexo, like this:

```
{% codeblock lang:html %}
<div>moo</div>
{% endcodeblock %}
```

A series of "Find and replace in files" actions took care of this. We also found a `syntax.styl` file to our liking. Not sure if Jekyll has built-in support for syntax highlighting. I suspect not and that it was automatically included with the [theme we chose for Jekyll](https://github.com/mmistakes/minimal-mistakes).

### CSS styles

Jekyll uses Kramdown for parsing Markdown. One of the features it adds is the ability to specify a class on your elements like so.

```
{: .pull-right }
![My image](http://my/image/reference)
```

This will add the `pull-right` CSS class to the image and, as the name suggests, this will float the image on the right.

As far as I know, there's no Kramdown support in NodeJS, likely because Kramdown is a Ruby gem. So we had to modify each instance of this syntax manually. For images, we converted to the Hexo [img tag plugin](https://hexo.io/docs/tag-plugins.html) like so:

```
{% img pull-right "http://my/image/reference" "My image"}
```

There are a few tag plugins in Hexo all ported from Octopress. Which likely means we could have used them in our Jekyll site but not much point in testing that out now...

For other instances of this kramdown-specific syntax that were applied to other elements, we just dropped down to native HTML in the Markdown:

```
<div class="notice">This is a notice</div>
```

### Aliases

We changed the URL structure for our podcasts early on and to keep any links pointing to the existing ones valid, we used [the jekyll-redirect-from gem](https://github.com/jekyll/jekyll-redirect-from) to maintain the old link. We find a [suitable replacement](https://github.com/jekyll/jekyll-redirect-from) for it in Hexo. BUT that suitable replacement's official package on NPM doesn't support Hexo 3 at the time of writing so we had to reference it in our `package.json` file like so:

```
"hexo-generator-alias": "git+https://github.com/hexojs/hexo-generator-alias.git"
```

Bear in mind that this is a static site. So both of these plugins, the Jekyll and the Hexo one, handle redirects with a static HTML page, like so:

```
<!DOCTYPE html><html><head><meta charset="utf-8"><title>Redirecting...</title><link rel="canonical" href="/podcasts/podcast-the-internet-of-things/"><meta http-equiv="refresh" content="0; url=/podcasts/podcast-the-internet-of-things/"></head></html>
```

This isn't quite ideal for SEO purposes but it is the recommended approach if you can't do a server-side redirect.

### Empty categories

This issue was probably the source of most of our trouble. Our permalink URL is of the form `/:category/:title`. For example: `/docker/yet-another-docker-intro/`. The issue is that the vast majority of our posts are uncategorized. And Jekyll and Hexo handles uncategorized posts very differently in their permalinks.

In the front matter for Hexo, you can define a default category which all posts will use if a category is not assigned. So if you set the default category to "moo", your permalink URL will be: `/moo/a-discussion-on-knockout/`.

In Jekyll, an uncategorized post appears at the root of the site. Like this one: `http://www.westerndevs.com/Migrating-from-Jekyll-to-Hexo-Part-2`. But setting the default category to an empty string or to `/`, let to fully-qualified URLs that look like this: `//Migrating-from-Jekyll-to-Hexo-Part-2`. I believe this is a bug in the permalink generator. It's generating the permalink as /category/title and when there is no category, it's not going to treat it any differently.

Our initial solution to this was to stick with a default category of `uncategorized` but to alias each post to the root so that existing URLs would still work but would redirect to the new one. Alas, we have Disqus comments to deal with and those are tied to a specific URL. We could have migrated them but we also would have had to contend with sucky looking URLs that have `uncategorized` in them.

Our current solution: [fork Hexo](https://github.com/westerndevs/hexo). In our fork, we add some handling when generating the URL for a post so that if it starts with a //, we trim one of them. Not the most elegant solution but workable for now. And if that's not hacky enough for you, check out the solution for...

### Permalinks/Disqus

After deployment, we discovered none of the existing Disqus comments were showing on our posts. The Disqus script was working because you could add new comments and it would show "Also on Western Devs" comments. Just no existing comments.

The culprit was, again, the permalink. Because of the leading //, Disqus thought the URL for our posts was (as an example): http://www.westerndevs.com//a-discussion-on-knockout. That double slash was enough to confuse it into not showing comments.

Our interim solution:

```
var disqus_url = '<%= page.permalink %>'.replace(".com//", ".com/");
```

This is a stopgap until we can dive into the Hexo code and determine the root cause.

### Feed/Sitemap/iTunes

This issue is more of a warning not to over-think things. Our feed is served up at http://www.westerndevs.com/feed. In Jekyll, we created a `feed.xml` file and assumed that it did some magic to generate a `feed` file. And we had a hell of a time trying to get Hexo to generate that same file without the .xml extension. Even to the point where we created our own package that still didn't quite work.

Then someone realized that Jekyll was not actually generating a `feed` file, just a `feed.xml` file. Whatever GitHub Pages runs on allows you to access XML files without the extension. Jekyll's development server knows this. Hexo's doesn't. So when we run locally, we can't access our various XML files (for our RSS feed, our iTunes feed, and our sitemap) without specifying the extension. But on the deployed site, they work fine.

### Links in Headers

There was a bug in the [default Markdown renderer](https://github.com/hexojs/hexo-renderer-marked) that caused rendering issues when you had links within headers. The bug has since been fixed but I'm including it here mostly to reiterate that you aren't locked into anything with Hexo. While we were converting, the bug was still active and all we did to fix it was to switch to [a different renderer](https://github.com/celsomiranda/hexo-renderer-markdown-it).

One philosophical point: One of the reasons for this bug is that the default renderer will automatically add bookmarks for every heading. This is a [design decision](https://github.com/hexojs/hexo-renderer-marked/issues/16) that I'm not convinced has a lot of value though it's not a position I'll defend strongly. The renderer we've switched to includes this as an option you have to explicitly turn on which I think is a better way to go.

### Deployment

Since GitHub Pages runs Jekyll, it's understandable that deployment with Jekyll is relatively easy. We did need to wrap it in a Rake task to accommodate working locally with a different `_config.yml` file than what is used in production but that wasn't hard to do.

For Hexo, our process is still mostly manual and has to be done locally rather than on our CI server (Travis). We generate the site, copy the static files to a folder, then check those files into the `gh-pages` branch. I imagine it [won't be hard](https://sazzer.github.io/blog/2015/05/04/Deploying-Hexo-to-Github-Pages-with-Travis/) to get our Travis process adapted to this but at present, we haven't got around to it yet. Just keep in mind, it won't be quite as easy as Jekyll.

### So which one is "better"?

I forgot to answer this in the last post. As I mentioned, we're enjoying Hexo and it's nice having everyone excited about blogging again. For the Western Devs as a group, Hexo is the better choice.

But personally, I like Jekyll a little better. It feels more polished and doesn't require you to fork the product to get what you want. Plus there's a larger and more comprehensive community behind it. That said, I am _really_ enjoying the quick generation time in Hexo.

---
I believe that covers the major gotchas we encountered in our conversion. It glosses over a few things, like whether to stick with Stylus as the default CSS pre-processor or move to SASS. Or whether to use [Jade](http://jade-lang.com/) as the templating language rather than the default, EJS. Those questions are quite a bit more subjective and I wanted to keep this discussion limited to the technical hurdles we encountered.

But if you run into an issue not mentioned here, add a comment.
