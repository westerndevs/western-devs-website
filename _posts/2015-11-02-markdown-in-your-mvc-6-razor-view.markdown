---
layout: post
title:  "Custom MVC6 Tag Helper Samples"
date: 2015-11-02T12:20:00-04:00
categories:
comments: true
author: dave_paquette
originalurl: http://www.davepaquette.com/archive/2015/11/02/markdown-in-your-mvc-6-razor-pages.aspx
---
# Markdown in your MVC 6 Razor Pages

What? Markdown in your Razor code? Yeah…and it was totally easy to build too.

[Taylor Mullen][1] demoed the idea of a [Markdown Tag Helper][2] idea at Orchard Harvest and I thought it would be nice to include this in my [Tag Helper Samples project][3].

This tag helper allows you to write Markdown directly in Razor and have that automatically converted to HTML at runtime. There are 2 options for how to use this tag helper. The first option is to use a _<markdown>_ element.

`<markdown>This is some _simple_ **markdown**.</markdown>`

The tag helper will take this and convert it to the following HTML:

`<p>This is some <em>simple</em> <strong>markdown</strong>.</p>`

The other option is to use a _<p>_ element that has the _markdown_ attribute:

`<p markdown="">This is some _simple_ **markdown** in a _p_ element.</p>`

The tag helper uses [MarkdownSharp][4], which supports most of the [markdown syntax supported by Stack Overflow][5].

The implementation of this tag helper is surprisingly simple. All we do is grab the contents of the tag and use MarkdownSharp to convert that to HTML.

```
    [HtmlTargetElement("p", Attributes = "markdown")]
    [HtmlTargetElement("markdown")]
    [OutputElementHint("p")]
    public class MarkdownTagHelper : TagHelper
    {
        public async override Task ProcessAsync(TagHelperContext context, TagHelperOutput output)
        {
            if (output.TagName == "markdown")
            {
                output.TagName = "p";
            }
            var childContent = await context.GetChildContentAsync();
            var markdownContent = childContent.GetContent();
            var markdown = new MarkdownSharp.Markdown();
            var htmlContent = markdown.Transform(markdownContent);
            output.Content.SetContentEncoded(htmlContent);
        }
    }
```

You can grab the code from [GitHub][3] or install the package using [Nuget][6].

    Install-Package TagHelperSamples.Markdown

Give it a try and let you know what you think.

[1]: https://twitter.com/ntaylormullen
[2]: https://www.youtube.com/watch?v=jD4H-CBab9o
[3]: https://github.com/dpaquette/TagHelperSamples
[4]: https://code.google.com/p/markdownsharp/
[5]: http://stackoverflow.com/editing-help
[6]: https://www.nuget.org/packages/TagHelperSamples.Markdown
  </markdown>
