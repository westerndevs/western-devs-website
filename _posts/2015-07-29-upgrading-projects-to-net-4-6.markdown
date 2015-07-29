---
layout: post
title:  "Upgrading Projects to .NET 4.6"
date: 2015-07-29T13:59:39+02:00
categories:
comments: true
author: james_chambers
originalurl: http://jameschambers.com/2015/07/upgrading-projects-to-net-4-6/
---

The updates in the .NET Framework provide many improvements, including support for new language features in c#, garbage collection, enhancements in cryptography support, feature toggles, new classes in the BCL and others. The RyuJIT compiler adds significant performance gains for 64bit applications, even those not originally targeting the 4.6, improves startup times and can reduce the memory footprint of your application.

{: .notice}
_In this series we're working through the conversion of an MVC 5-based application and migrating it to MVC 6. You can track the entire series of posts from the [intro page][1]._

While the explicit modification of your projects may not be required to gain some of the 4.6 benefits, there may be other organizational factors that lead you down that path. We'll work through the mechanics of the upgrade to 4.6 in this post.

## <i class="fa fa-warning" /> A Word of Caution

UPDATE: July 28, 2015 There is a known issue with certain 64bit applications running on .NET 4.6, under certain circumstances, with certain parameter types and sizes. You can read more [about the bug finding here][2] and the issue is being [tracked on GitHub][3], followed by Microsoft's [response and recommendation][4].

{: .notice}
For this reason **I am not recommending an upgrade to 4.6** unless you understand the implications and how to properly vet the scenarios described in your environment.

## Getting Your Projects Up-to-date

Every project we create references a specific version of the .NET Framework. This has been true throughout the history of .NET, and though the way we will do it in the future will change with the new project system, the premise remains the same.

For now, you can simply open the properties tab for your project and change the target Framework.

![image][5]

You will be prompted to let you know that some changes may be required.

![image][6]

Note that in my case, I had 7 projects with varying types of references and dependencies, and no modifications were required to the code. Your mileage may vary, of course, but this is a simple change and one that you can test quickly. With proper source control in place, this is a zero-risk test that should take only a moment or two.

Now, if you were to try to build the Bootcamp project when you're only partway through the upgrade, you'd see something similar to the following:

![image][7]

With a message that reads:

> The primary reference "x" could not be resolved because it was built against the ".NETFramework,Version=v4.6" framework. The is a higher version than the currently targeted framework ".NETFramework,Version=4.5.1".

You may run into this in other scenarios, as well, especially if you you have references to packages or libraries that get out of sync in your upgrade process. **A project that takes on dependencies must be at (or higher than) the target framework of the compiled dependencies**. To remedy this, we simply need to complete the upgrade process on the rest of the projects.

![image][8]

This was pretty painless. ![Smile][9]

## Reasons to Upgrade?

Moving from 4.5.x to 4.6 is not a required step in our conversion to an MVC 6 project. In fact, MVC 6 indeed runs on a different framework altogether. To that end, any environment where you have 4.6 installed will "pull up" other assemblies because it is a drop-in replacement for pervious versions.

Perhaps your primary motivator to move to 4.6 is the perf bump in the runtime, or it might be the new language features (which only require a framework install, not a version bump in your target). But it also ensures we're compatible with other projects in our organization, particularly when we consider the default target for new projects in VS 2015 is against 4.6. If we want to leverage these from other projects in our organization, we want to make sure that we're not the lowest common denominator in the mix.

## The Next Step

However, there are a couple of other points that we should note, namely that our compiler isn't tied to the installed framework or the runtime, it's just used to _target_ a specific set of instructions that the runtime can digest. So, if our MVC 6 will be running on DNX46, or we have other .NET 4.6 projects we're all set (though, we'd have to use DNU wrap to consume our library at this point in DNX).

But what if we have different projects across our organization, or we have external teams using our libraries? The answer lies in multi-targeting, which is what we'll address in the next post in this series.

Until then, happy coding! ![Smile][9]

[1]: http://jameschambers.com/2015/07/upgrading-a-real-world-mvc-5-application-to-mvc-6/
[2]: http://nickcraver.com/blog/2015/07/27/why-you-should-wait-on-dotnet-46/
[3]: https://github.com/dotnet/coreclr/issues/1296
[4]: http://blogs.msdn.com/b/dotnet/archive/2015/07/28/ryujit-bug-advisory-in-the-net-framework-4-6.aspx
[5]: http://jameschambers.com/wp-content/uploads/2015/07/image18.png "image"
[6]: http://jameschambers.com/wp-content/uploads/2015/07/image19.png "image"
[7]: http://jameschambers.com/wp-content/uploads/2015/07/image20.png "image"
[8]: http://jameschambers.com/wp-content/uploads/2015/07/image21.png "image"
[9]: http://jameschambers.com/wp-content/uploads/2015/07/wlEmoticon-smile5.png
  