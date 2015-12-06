---
layout: post
title:  "ApiController in ASP.NET 5? Nopesauce"
date: 2015-11-02T19:44:15-05:00
comments: true
authorId: james_chambers
originalurl: http://jameschambers.com/2015/11/apicontroller-in-asp-net-5-nopesauce/
---

If you're developing in ASP.NET Web API you are familiar with the concept of inheriting from the base ApiController class. This class is still around in ASP.NET 5, but it is likely not meant for you to use.&nbsp; Here's why your cheese has moved.

> **TL;DR**: Going forward, you're going to inherit from Controller instead of ApiController, or from nothing at all.

## How We Used to Do It

This is pretty much the bread and butter of a new controller in an old Web API 2.0 project:

{% codeblock lang:csharp %}
public class ValuesController : ApiController
{
    [HttpGet]
    public IEnumerable<string> Get()
    {
        return new string[] { "value1", "value2" };
    }
}
{% endcodeblock %}

Nothing really too interesting here. We're inheriting from a base class so we get some methods to leverage for return types, we can access the identity of the user through an IPrincipal and we have an HttpContext available to inspect the request and modify the response.

## How to Do it Now

In ASP.NET 5 we don't have the ApiController to inherit from, at least not out of the box. Instead we inherit from the Controller class.

{% codeblock lang:csharp %}
public class ValuesController : Controller
{
    [HttpGet]
    public IEnumerable<string> Get()
    {
        return new string[] { "value1", "value2" };
    }
}
{% endcodeblock %}

Pretty easy, right? We actually have three less characters. Some pieces have moved around such as Request and Response objects that live as properties at the class level, and our User is now a ClaimsPrincipal instead of an IPrincipal. You'll also find that there's a host of other things that do not seem really relevant at first glance to Web API (things like the service resolver and TempData).

These extra bits are peripheral, however; the takeaway is actually that we no longer have two separate sets of classes that represent concerns like controllers or routing, and we can go about getting at the important parts of the request in the same way from both types of controllers – there really is just one now.

## If You Still Want to Do It Now How We Used To

There are perfectly good reasons to keep using the old format, perhaps you're at the start of a port project or some have some other reason to stay as-was. No problem, you're just going to have to pull in another package as it's not part of your project template by default. Simply edit your project.json to include the following package:

    Microsoft.AspNet.Mvc.WebApiCompatShim

While this _is_ here and you _can_ use it, it's also likely a good time to evaluate if you _need_ to use it. There are only a small set of refactorings that are required in order to use the unified interface and you can be

## Next Steps

Make sure you've got [Visual Studio 2015][1], you have [the latest beta installed][2] (at time of writing, beta 8), and give it a try. Happy coding ![Smile][3]

[1]: https://www.visualstudio.com/?Wt.mc_id=DX_MVP4038205
[2]: http://docs.asp.net/en/latest/getting-started/installing-on-windows.html
[3]: http://jameschambers.com/wp-content/uploads/2015/11/wlEmoticon-smile.png
