---
title: My Hasty Move to Hexo
categories:
  - hexo
tags:
  - blogging
  - azure
  - hexo
date: 2015-12-28 17:00:00
authorId: dave_paquette
excerpt: I have meant for some time now to move my blog to something a little more stable. Wordpress is a fine platform but really overkill for what I need.
---

As I mentioned in my last post, I had some downtime on my blog after [my database mysteriously disappeared](http://davepaquette.com/archive/2015/12/03/the-case-of-the-disappearing-database.aspx). 

I have meant for some time now to move my blog to something a little more stable. Wordpress is a fine platform but really overkill for what I need. After moving all my comments to [Disqus](https://disqus.com/) earlier this year I really had no need at all for a database backend. More importantly, I found it difficult to fine-tune things in Wordpress. Not because it is necessarily difficult to do these things in Wordpress but because have absolutely no interest in learning php.

## A Quick Survey
I wanted to move to a statically generated site. I like writing my posts in Markdown and I like the simplicity of a statically generated site. I had a quick look at [this site](https://www.staticgen.com/) that provides a list of the most popular static site generators.

Jekyll is definitely a great option and seems to be the most popular. At the time, we were using it over at [Western Devs](http://www.westerndevs.com). The main problem I have with Jekyll is that it is a bit of a pain to get working on Windows.

I noticed a handy Language filter on the site and picked .NET. There are a few options there but nothing that seems to have any great traction.

Next I picked JavaScript/Node. I am reasonably proficient at JavaScript and I use Node for [front-end web dev](http://www.davepaquette.com/categories/Web-Dev/) tasks every day. In that list, Hexo seemed to be the most popular. After polling the group at Western Devs I found out that [David Wesst](http://www.westerndevs.com/bios/david_wesst/) was also using Hexo. This is great for me because Wessty is our resident Node / JavaScript expert. With an expert to fall back on in an emergency situation, I forged ahead in my move to Hexo.

## Moving from Wordpress

Hexo provides a plugin for importing from Wordpress. All I did here was followed the steps in the [migration documentation](https://hexo.io/docs/migration.html#WordPress). All my posts came across as expected. The only thing that bothered me with the posts is that I lost syntax highlighting on my code blocks. Fixing this was a bit of a manual process, wrapping my code blocks as follows: 

```
{% codeblock lang:html %}
<div>...</div>
{% endcodeblock %}
```

I did this for my 40 most popular blog posts which covers about 80% of the traffic to my blog. Good enough for me.

Next, I needed to pull down my images. I serve my images on my blog site (I know...I should be hosting this somewhere else like blob storage or imgr). To fix this, I simply used FTP to copy the images from down from my old site and put them in the Hexo `source` folder. I my case that was the `source\wp-content\uploads` folder.

## Deploying to Azure

I decided to keep my blog hosted in Azure. To deploy to Azure using Hexo, I am using the [git deploy method](https://hexo.io/docs/deployment.html#Git). With this method, anytime I call `hexo deploy --generate`, Hexo will generate my site and then commit the generated site to a particular branch in my git repository. I then use the [Web App continuous deployment hooks](https://azure.microsoft.com/en-us/documentation/articles/web-sites-publish-source-control/) in Azure to automatically update the site whenever a change is pushed to that branch.

## Some Issues with Hexo
Since I moved my blog over, WesternDevs has also [moved to Hexo](http://www.westerndevs.com/jekyll/hexo/Migrating-from-Jekyll-to-Hexo/) as part of a big site redesign. [Kyle Baley](http://www.westerndevs.com/bios/kyle_baley/) has done a good job of documenting some of the [issues we encountered](http://www.westerndevs.com/jekyll/hexo/Migrating-from-Jekyll-to-Hexo-Part-2/) along the way.

I ran into a few more specific issues. First of all, I didn't want to break all my old links so I kept the same permalinks as my old blog. The challenge with that is that each url ends in .aspx. Weird right...my old blog was Wordpress (php) but before Wordpress I was on geekswithblogs which was using some ASP.NET based blogging engine. So here I am in 2015 with a statically generated blog that is created using Node and is hosted in Azure that for some reason has `.aspx` file endings. The problem with this was that Aure uses IIS and tries to process the `aspx` files using the ASP.NET page handlers. Initially everything looked okay. The pages were still being served but some of the characters were not encoded properly. The solution here was to add a `web.config` to my Hexo `source` folder. In the `web.config` I was able to turn off the ASP.NET page handlers and tell IIS that `.aspx` pages should be treated as static content:

{% codeblock lang:xml %}
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <handlers>
            <remove name="PageHandlerFactory-ISAPI-2.0-64" />
            <remove name="PageHandlerFactory-ISAPI-2.0" />
            <remove name="PageHandlerFactory-Integrated" />
            <remove name="PageHandlerFactory-ISAPI-4.0_32bit" />
            <remove name="PageHandlerFactory-Integrated-4.0" />
            <remove name="PageHandlerFactory-ISAPI-4.0_64bit" />
        </handlers>
        <staticContent>
            <clientCache cacheControlCustom="public" cacheControlMode="UseMaxAge" cacheControlMaxAge="7.00:00:00" /> 
            <mimeMap fileExtension=".aspx" mimeType="text/html" />
            <mimeMap fileExtension=".eot" mimeType="application/vnd.ms-fontobject" />
            <mimeMap fileExtension=".ttf" mimeType="application/octet-stream" />
            <mimeMap fileExtension=".svg" mimeType="image/svg+xml" />
            <mimeMap fileExtension=".woff" mimeType="application/font-woff" />
            <mimeMap fileExtension=".woff2" mimeType="application/font-woff2" />
        </staticContent>
        <rewrite>
            <rules>
                <rule name="RSSRewrite" patternSyntax="ExactMatch">
                    <match url="feed" />
                    <action type="Rewrite" url="atom.xml" appendQueryString="false" />
                </rule>
                <rule name="RssFeedwithslash">
                    <match url="feed/" />
                    <action type="Rewrite" url="atom.xml" appendQueryString="false" />
                </rule>
            </rules>
        </rewrite>
    </system.webServer>
</configuration>
{% endcodeblock %}

In the `web.config` I also added a rewrite rule to preserve the old RSS feed link. 

## Triggering a mass migration
While not perfect, I have been happy with my experience migrating to Hexo. Overall, I was able to complete my initial migration within a few hours. Converting older posts to use syntax highlighting took a litte longer but I was able to do that in phases.  

I talked about my experience over at Western Devs and this seems to have triggered a few of us to also move our blogs over to Hexo. Hopefully that decision does come back to bite me later...so far it is working out well.  


