---
layout: post
title:  "Creating custom MVC 6 Tag Helpers"
date:   2015-06-22 20:09:05
author: dave_paquette
originalurl: http://www.davepaquette.com/archive/2015/06/22/creating-custom-mvc-6-tag-helpers.aspx
categories:
comments: true
---
In the last few blog posts, I have spent some time covering the tag helpers that are built in to MVC 6. While the built in tag helpers cover a lot of functionality needed for many basic scenarios, you might also find it beneficial to create your tag helpers from time to time.

In this post, I will show how you can easily create a simple tag helper to generate a Bootstrap progress bar. _NOTE: Thank you to [James Chambers][1] for giving me the idea to look at bootstrap components for ideas for custom tag helpers._

<!--more-->

Based on the documentation for the bootstrap [progress bar component][2], we need to write the following HTML to render a simple progress bar:

{% highlight html %}
<div class="progress">
  <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
    <span class="sr-only">60% Complete</span>
  </div>
</div>
{% endhighlight %}

This is a little verbose and it can also be easy to forget some portion of the markup like the aria attributes or the role attribute. Using tag helpers, we can make the code easier to read and ensure that the HTML output is consistent everywhere we want to use a bootstrap progress bar.

## Choosing your syntax

With tag helpers, you can choose to either create your own custom tag names or augment existing tags with special tag helper attributes. Examples of custom tags would be the [environment tag helper][3] and the [cache tag helper][4]. Most of the other built in MVC 6 tag helpers target existing HTML tags. Take a look at the [input tag helper][5] and the [validation tag helper][6] for examples.

At this point, I'm not 100% sure when one is more appropriate than the other. Looking at the built in MVC 6 tag helpers, the only tag helpers that target new elements are those that don't really have a corresponding HTML element that would make sense. Mostly, I think it depends on what you want your cshtml code to look like and this will largely be a personal preference. In this example, I am going to choose to target the `<div>` tag but I could have also chosen to create a new `<bs_progress_bar>` tag. The same thing happens in the angularjs world. Developers in angularjs have the option to create declare directives that are used as attributes or as custom elements. Sometimes there is an obvious choice but often it comes down to personal preference.

So, what I want my markup to look like is this:

{% highlight html %}
<div bs-progress-value="@Model.CurrentProgress" 
     bs-progress-max="100" 
     bs-progress-min="0">
</div>
{% endhighlight %}

Now all we need to do is create a tag helper turn this simplified markup into the more verbose markup needed to render a bootstrap progress bar.

## Creating a tag helper class

Tag helpers are pretty simple constructs. They are classes that inherit from the base TagHelper class. In this class, you need to do a few things.

First, you need to specify a TargetElement attribute: this is what tells Razor which HTML tags / attributes to associate with this tag helper. In our case, we want to target any 
 element that has the bs-progress-value element.

{% highlight c# %}
[TargetElement("div", Attributes = ProgressValueAttributeName)]
public class ProgressBarTagHelper : TagHelper
{
    private const string ProgressValueAttributeName = "bs-progress-value";    
    //....
}
{% endhighlight %}

The Attributes parameter for the TargetElement is a coma separated list of attributes that are _required _for this tag helper. I'm not making the bs-progress-min and bs-progress-max attributes required. Instead, I am going to give them a default of 0 and 100 respectively. This brings us to the next steps which is defining properties for any of the tag helper attributes. Define these as simple properties on the class and annotate them with an HtmlAttributeName attribute to specify the attribute name that will be used in markup.

{% highlight c# %}
[TargetElement("div", Attributes = ProgressValueAttributeName)]
public class ProgressBarTagHelper : TagHelper
{
    private const string ProgressValueAttributeName = "bs-progress-value";
    private const string ProgressMinAttributeName = "bs-progress-min";
    private const string ProgressMaxAttributeName = "bs-progress-max";
   
    [HtmlAttributeName(ProgressValueAttributeName)]
    public int ProgressValue { get; set; }
 
    [HtmlAttributeName(ProgressMinAttributeName)]
    public int ProgressMin { get; set; } = 0;
 
    [HtmlAttributeName(ProgressMaxAttributeName)]
    public int ProgressMax { get; set; } = 100;
 
    //...
}
{% endhighlight %}

These attributes are strongly typed which means Razor will give you errors if someone tries to bind a string or a date to one of these int properties.

Finally, you need to override either the Process or the ProcessAsync method. In this example, the logic is simple and does not require any async work to happen so it is probably best to override the Process method. If the logic required making a request or processing a file, you would be better off overriding the ProcessAsync method.

{% highlight c# %}
[TargetElement("div", Attributes = ProgressValueAttributeName)]
public class ProgressBarTagHelper : TagHelper
{
    private const string ProgressValueAttributeName = "bs-progress-value";
    private const string ProgressMinAttributeName = "bs-progress-min";
    private const string ProgressMaxAttributeName = "bs-progress-max";
    
    /// <summary>
    /// An expression to be evaluated against the current model.
    /// </summary>
    [HtmlAttributeName(ProgressValueAttributeName)]
    public int ProgressValue { get; set; }
 
    [HtmlAttributeName(ProgressMinAttributeName)]
    public int ProgressMin { get; set; } = 0;
 
    [HtmlAttributeName(ProgressMaxAttributeName)]
    public int ProgressMax { get; set; } = 100;
 
    public override void Process(TagHelperContext context, TagHelperOutput output)
    {
        var progressTotal = ProgressMax - ProgressMin;
 
        var progressPercentage = Math.Round(((decimal) (ProgressValue - ProgressMin) / (decimal) progressTotal) * 100, 4);
 
        string progressBarContent =
            string.Format(
@"<div class='progress-bar' role='progressbar' aria-valuenow='{0}' aria-valuemin='{1}' aria-valuemax='{2}' style='width: {3}%;'> 
<span class='sr-only'>{3}% Complete</span>
</div>", ProgressValue, ProgressMin, ProgressMax, progressPercentage);
 
        output.Content.Append(progressBarContent);
 
        string classValue;
        if (output.Attributes.ContainsKey("class"))
        {
            classValue = string.Format("{0} {1}", output.Attributes["class"], "progress");
        }
        else
        {
            classValue = "progress";
        }
        
        output.Attributes["class"] = classValue;
    }
}
{% endhighlight %}

The Process method has 2 parameters: a TagHelperContext and a TagHelperOutput. In this simple example, we don't need to worry about the TagHelperContext. It contains information about the input element such as the attributes that were specified there and a unique ID that might be needed if multiple instances of the tag helpers were used on a single page. The TagHelperOutput is where we need to specify the HTML that will be output by this tag helper. We start by doing some basic math to calculate the percentage complete of the progress bar. Next, I used a string.Format to build the inner HTML for the bootstrap progress bar with the specified min, max, value and calculated percentages. I add this to the contents of the output by calling output.Content.Append. The last step is to add class="progress" to the outer div. I can't just add the attribute though because there is a chance that the developer has already specified another class for this div (it is possible that we want the output to be _class="green progress"_.

If you need to build more complicated HTML in the content, you should consider using the [TagBuilder class][7]. If a tag helper grows too complex, you might want to consider creating a View Component instead.

Finally, we should add some argument checking to make sure that the Min / Max and Value properties are appropriate. For example, the ProgressMin value should be less than the ProgressMax value. We can throw argument exceptions to clearly indicate errors. Here is the finally implementation of the ProgressBarTagHelper:

{% highlight c# %}
[TargetElement("div", Attributes = ProgressValueAttributeName)]
public class ProgressBarTagHelper : TagHelper
{
    private const string ProgressValueAttributeName = "bs-progress-value";
    private const string ProgressMinAttributeName = "bs-progress-min";
    private const string ProgressMaxAttributeName = "bs-progress-max";
    
    /// <summary>
    /// An expression to be evaluated against the current model.
    /// </summary>
    [HtmlAttributeName(ProgressValueAttributeName)]
    public int ProgressValue { get; set; }
 
    [HtmlAttributeName(ProgressMinAttributeName)]
    public int ProgressMin { get; set; } = 0;
 
    [HtmlAttributeName(ProgressMaxAttributeName)]
    public int ProgressMax { get; set; } = 100;
 
    public override void Process(TagHelperContext context, TagHelperOutput output)
    {
        if (ProgressMin >= ProgressMax)
        {
            throw new ArgumentException(string.Format("{0} must be less than {1}", ProgressMinAttributeName, ProgressMaxAttributeName));
        }
 
        if (ProgressValue > ProgressMax || ProgressValue < ProgressMin)
        {
            throw new ArgumentOutOfRangeException(string.Format("{0} must be within the range of {1} and {2}", ProgressValueAttributeName, ProgressMinAttributeName, ProgressMaxAttributeName));
        }
        var progressTotal = ProgressMax - ProgressMin;
 
        var progressPercentage = Math.Round(((decimal) (ProgressValue - ProgressMin) / (decimal) progressTotal) * 100, 4);
 
        string progressBarContent =
            string.Format(
@"<div class='progress-bar' role='progressbar' aria-valuenow='{0}' aria-valuemin='{1}' aria-valuemax='{2}' style='width: {3}%;'> 
<span class='sr-only'>{3}% Complete</span>
</div>", ProgressValue, ProgressMin, ProgressMax, progressPercentage);
 
        output.Content.Append(progressBarContent);
 
        string classValue;
        if (output.Attributes.ContainsKey("class"))
        {
            classValue = string.Format("{0} {1}", output.Attributes["class"], "progress");
        }
        else
        {
            classValue = "progress";
        }
        
        output.Attributes["class"] = classValue;
        
        base.Process(context, output);
    }
}
{% endhighlight %}

## Referencing the custom Tag Helper

Before we can start using our custom tag helper, we need to add a reference to the tag helpers in the current assembly using the @addTagHelper Razor command. We can do this in individual Razor files or we can add it the _GlobalImports.cshtml file so it is applied everywhere:

{% highlight c# %}
@using WebApplication3
@using WebApplication3.Models
@using Microsoft.Framework.OptionsModel
@using Microsoft.AspNet.Identity
@addTagHelper "*, Microsoft.AspNet.Mvc.TagHelpers"
@addTagHelper "*, WebApplication3"  
{% endhighlight %}

Now we can reference the tag helper in any of our Razor views. Here is an example binding the PercentComplete property from the model to the ProgressValue property of the tag helper.

{% highlight html %}
<div bs-progress-value="@Model.PercentComplete"></div>
{% endhighlight %}

Here is another example that would display progress for a 5 step process:

{% highlight html %}
<div bs-progress-min="1"
     bs-progress-max="5"
     bs-progress-value="@Model.CurrentStep">
</div>
{% endhighlight %}

### Unit Testing

Tag Helpers are easy enough to unit test and I would definitely recommend that you do test them. Take a look at [these examples][8] in the MVC 6 repo for reference.

## Conclusion

By creating this simple tag helper, we are able to greatly simplify the Razor code required to create a bootstrap progress bar with a value from the our model. As a result, our Razor view is easier to understand and we can ensure a consistent output for all progress bars in our app. If we needed to change the way we rendered progress bars, we would only need to change the code in one place. This is of course a relatively simple example but I think it shows the potential for tag helpers in MVC 6.

[1]: http://jameschambers.com/
[2]: http://getbootstrap.com/components/#progress
[3]: http://www.davepaquette.com/archive/2015/05/05/web-optimization-development-and-production-in-asp-net-mvc6.aspx
[4]: http://www.davepaquette.com/archive/2015/06/03/mvc-6-cache-tag-helper.aspx
[5]: http://www.davepaquette.com/archive/2015/05/13/mvc6-input-tag-helper-deep-dive.aspx
[6]: http://www.davepaquette.com/archive/2015/05/14/mvc6-validation-tag-helpers-deep-dive.aspx
[7]: https://github.com/aspnet/Mvc/blob/dev/src/Microsoft.AspNet.Mvc.Extensions/Rendering/Html/TagBuilder.cs
[8]: https://github.com/aspnet/Mvc/tree/dev/test/Microsoft.AspNet.Mvc.TagHelpers.Test
  
