---
layout: post
title:  "Adding Prefixes to Tag Helpers in MVC 6"
date: 2015-09-03T17:24:56-04:00
categories:
comments: true
author: dave_paquette
originalurl: http://www.davepaquette.com/archive/2015/09/03/adding-prefixes-to-tag-helpers-in-mvc-6.aspx
---

Some people have said that they would prefer all Tag Helper elements in MVC 6 to be prefixed. I honestly don't see myself doing this but it is easy to turn on if you prefer tag helper elements to be prefixed with some special text.

Simply add the @tagHelperPrefix directive to the _ViewImports.cshtml file in your project:

    @tagHelperPrefix "th:"

Now, Razor will only recognize elements as Tag Helpers if the elements are prefixed with "th:".

![image][1]

You can choose whatever prefix you want for your project. As I said, I probably won't be using this myself but at least there is an easy way to turn on tag helper prefixes for those who want to be very explicit about tag helpers.

One nice thing with prefixes is that it enables is a quick way to identify what tag helpers exist in a project. When you type in the prefix, IntelliSense will show you a list of elements that can be processed by tag helpers:

![image][2]

What do you think? Prefix or not prefix?

[1]: http://www.davepaquette.com/wp-content/uploads/2015/09/image_thumb.png "image"
[2]: http://www.davepaquette.com/wp-content/uploads/2015/09/image_thumb1.png "image"
  