---
layout: post
title:  MVC 6 Image Tag Helper
date: 2015-07-02T09:39:40-04:00
categories:
comments: true
authorId: dave_paquette
originalurl: http://www.davepaquette.com/archive/2015/07/01/mvc-6-image-tag-helper.aspx
alias: /mvc-6-image-tag-helper/
---

[ASP.NET 5 Beta 5](http://blogs.msdn.com/b/webdev/archive/2015/06/30/asp-net-5-beta5-now-available.aspx) shipped yesterday and it includes a new tag helper: the [Image tag helper](https://github.com/aspnet/Mvc/blob/dev/src/Microsoft.AspNet.Mvc.TagHelpers/ImageTagHelper.cs). While this is a very simple tag helper, it has special meaning for me. Implementing this tag helper was [my first pull request](https://github.com/aspnet/Mvc/pull/2516) submitted to the aspnet/mvc repo.

So, what does this tag helper do? If you add the asp-file-version=”true” attribute to an image tag, the tag helper will automatically append a version tag to the image file path. This allows you to aggressively cache an image without worrying about updated images not being sent to the client.

Using it is simple. Just add asp-file-version=”true” to a standard img tag:

{% codeblock lang:html %}
<img src="~/images/logo.png" 
     alt="company logo" 
     asp-file-version="true" />
{% endcodeblock %}

which will generate something like this:

{% codeblock lang:html %}
<img src="/images/logo.png?v=W2F5D366_nQ2fQqUk3URdgWy2ZekXjHzHJaY5yaiOOk" 
     alt="company logo"/>
{% endcodeblock %}

The value of the v parameter is calculated based on the contents of the image file. If the contents of the image change, the value of the parameter will change. This forces the browser to download the new version of the file, even if the old version was cached locally. This technique is often called cache busting.

Note that the attribute is named asp-file-version in Beta 5 but if you are using the Dev or Beta 6 bits it has been renamed to asp-append-version.

As I said, this is very simple tag helper but I find it to be very useful. I have been caught more than once with updated images not showing up for clients that had older versions cached locally. One recent example was when I was iterating quickly through logo designs for a site that was live in production. I could have changed the logo filename every time I updated the logo but this would have been tedious. Cache busting with the image tag helper allows me to update the image contents without having to rename the file or worry about manually changing the references to that image.
