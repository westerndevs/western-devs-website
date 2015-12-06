---
layout: post
title:  Response From Postsharp.net Is Not a Valid Nuget V2 Service Response
date: 2015-07-22T14:16:30-04:00
categories:
comments: true
authorId: james_chambers
originalurl: http://jameschambers.com/2015/07/response-from-postsharp-net-is-not-a-valid-nuget-v2-service-response/
---

After installing PostSharp.net on my machine for a project (I did the MSI install) I started getting errors during the package restore that ended up blocking my builds. They looked a lot like this:

> Error: FindPackagesById: EntityFramework.Core Response from https://www.postsharp.net="" nuget="" packages="" findpackagesbyid()?id="EntityFramework.Core" is not a valid NuGet v2 service response.

![image][1]

Now, an important note here: I'm on a machine that's seen various updates and changes to VS 2015, and this was a version of PostSharp that wasn't originally built for the RTM version of Visual Studio. So…this may be entirely circumstantial, but it's what I ran into.

And it wasn't just on that one package (others would give the same result) and it wasn't just on one project. I tried to isolate this, but couldn't find the source. Why was PostSharp getting in the way of my package restore? Even using DNU from the command line, **_after_** I explicitly uninstalled it? I started setting compiler variables to block PostSharp on those projects, but that got frustrating quickly, so I resorted to uninstalling everything I could find of it.

After the uninstall, I still was stumped, same errors all over again. With the help of my friend [Donald Belcham][2], I was able to find traces of PostSharp still on my machine, located in the system-wide NuGet package source feed configuration:

![image][3]

Unchecking that box above does the trick.

Might be an edge case if you run into this, but if you do, and this helps, consider buying Don a scotch!

Happy coding. ![Smile][4]

[1]: http://jameschambers.com/wp-content/uploads/2015/07/image1.png "image"
[2]: https://twitter.com/dbelcham
[3]: http://jameschambers.com/wp-content/uploads/2015/07/image2.png "image"
[4]: http://jameschambers.com/wp-content/uploads/2015/07/wlEmoticon-smile1.png
