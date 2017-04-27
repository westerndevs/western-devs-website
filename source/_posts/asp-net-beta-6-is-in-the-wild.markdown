---
layout: post
title:  "ASP.NET Beta 6 Is in the Wild"
date: 2015-07-29T14:17:59+02:00
categories:
comments: true
authorId: james_chambers
originalurl: http://jameschambers.com/2015/07/asp-net-5-beta-6-is-in-the-wild/
---
The Beta 6 release of ASP.NET 5 is now available. Run the following command to upgrade from a previous version:

    dnvm upgrade

After that, a "dnvm list" command will give you the following:

<!--more-->

![image][1]

You can also upgrade dnvm itself with the following command:

    dnvm update-self

Which will get you up to the beta 7 version (build 10400) of DNVM.

![image][2]

You'll also need the updated VS 2015 tooling, which is available here (along with the DNVM update tools if you want them seperately): <span style="text-decoration: line-through;">Microsoft Visual Studio 2015 Beta 6 Tooling Download</span> (no longer active).

## Why This is Important

As part of my progression in porting an MVC 5 app to MVC 6, one scenario that I needed support for was to have libraries targeting .NET 4.6 reference-able from a DNX project. MVC 6, up to this point, only supported 4.5.1, which meant that you'd have to roll back your targeting if you were on 4.5.2 or 4.6.

Of course, multi-targeting is a better option, but requires the time and capacity to either slave over the old code base and NuGet packaging nuances, or port to the new project format where you have much greater in-project support for targeting multiple frameworks.

## What You Get

As previously detailed by [Damien Edwards][4], there are bug fixes, features and improvements in the following areas: [Runtime][5], [MVC][6], [Razor][7], [Identity][8]. In addition to supporting .NET 4.6 in DNX, they have also added localization and have been working on other things like distributed caching, which you can [read about here][9].

## What To Watch Out For

This is still a beta, and there are many moving parts.

Be sure to check out the [community standup today][10] and head over to [GitHub][11] for the announcements on [breaking changes][12].

Happy coding! ![Smile][13]

[1]: https://jcblogimages.blob.core.windows.net/img/2015/07/image22.png "image"
[2]: https://jcblogimages.blob.core.windows.net/img/2015/07/image_thumb6.png "image"
[4]: https://twitter.com/DamianEdwards
[5]: https://github.com/issues?utf8=%E2%9C%93&amp;q=user%3Aaspnet+is%3Aissue+label%3Aenhancement+milestone%3A1.0.0-beta6
[6]: https://github.com/issues?utf8=%E2%9C%93&amp;q=user%3Aaspnet+is%3Aissue+label%3Aenhancement+milestone%3A6.0.0-beta6
[7]: https://github.com/issues?utf8=%E2%9C%93&amp;q=user%3Aaspnet+is%3Aissue+label%3Aenhancement+milestone%3A4.0.0-beta6
[8]: https://github.com/issues?utf8=%E2%9C%93&amp;q=user%3Aaspnet+is%3Aissue+label%3Aenhancement+milestone%3A3.0.0-beta6
[9]: https://github.com/aspnet/Announcements/issues/43
[10]: https://live.asp.net/
[11]: https://github.com/aspnet/
[12]: https://github.com/aspnet/Announcements/issues
[13]: https://jcblogimages.blob.core.windows.net/img/2015/07/wlEmoticon-smile4.png
