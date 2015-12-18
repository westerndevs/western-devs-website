---
layout: post
title:  Markdown in Your MVC 6 Razor Pages
date: 2015-11-02T17:02:42-05:00
comments: true
authorId: dave_paquette
originalurl: http://www.davepaquette.com/archive/2015/11/02/markdown-in-your-mvc-6-razor-pages.aspx
---

What? Markdown in your Razor code? Yeah...and it was totally easy to build too.

[Taylor Mullen][1] demoed the idea of a [Markdown Tag Helper][2] idea at Orchard Harvest and I thought it would be nice to include this in my [Tag Helper Samples project][3].

<!--more-->
  
## How to use it

This tag helper allows you to write Markdown directly in Razor and have that automatically converted to HTML at runtime. There are 2 options for how to use this tag helper. The first option is to use a `<markdown>` element.

{% codeblock lang:xml %}
<code><markdown>This is some _simple_ **markdown**.</markdown></code>
{% endcodeblock %}

The tag helper will take this and convert it to the following HTML:

{% codeblock lang:html %}
<p>This is some <em>simple</em> <strong>markdown</strong>.</p>
{% endcodeblock %}

The other option is to use a `<p>` element that has the _markdown_ attribute:

{% codeblock lang:html %}
<p markdown="">This is some _simple_ **markdown** in a _p_ element.</p>
{% endcodeblock %}

The tag helper uses [MarkdownSharp][4], which supports most of the [markdown syntax supported by Stack Overflow][5].

## How it works

The implementation of this tag helper is surprisingly simple. All we do is grab the contents of the tag and use MarkdownSharp to convert that to HTML.

{% codeblock lang:csharp %}
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
{% endcodeblock %}

You can grab the code from [GitHub][3] or install the package using [Nuget][6].

> Install-Package TagHelperSamples.Markdown

Give it a try and let me know what you think.

[1]: https://twitter.com/ntaylormullen
[2]: https://www.youtube.com/watch?v=jD4H-CBab9o
[3]: https://github.com/dpaquette/TagHelperSamples
[4]: https://code.google.com/p/markdownsharp/
[5]: http://stackoverflow.com/editing-help
[6]: https://www.nuget.org/packages/TagHelperSamples.Markdown
