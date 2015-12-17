---
layout: post
title:  "Workaround: NuGet Packages Failing to Download in Visual Studio 2015 RTM"
date: 2015-07-23T10:05:26-04:00
categories:
comments: true
authorId: james_chambers
originalurl: http://jameschambers.com/2015/07/workaround-nuget-packages-failing-to-download-in-visual-studio-2015-rtm/
alias: /workaround-nuget-packages-failing-to-download-in-visual-studio-2015-rtm/
---

I haven't figured out a common theme yet, but certain packages are failing to restore when you attempt to install them from the NuGet primary feed via the project.json file in Visual Studio 2015. Thanks to [Brock Allen][1] for confirming I wasn't going insane.

A couple of things I've discovered:

* This seems to be more common for prerelease packages
* It seems to work if the package has a previous release version (not in pre)

As a workaround, you can add the packages manually via the dialog in Visual Studio, just make sure you hit that pre-release flag:

![image][2]

If that doesn't work for you – sometimes I'm not seeing the package above in my feed – if you have it you can add another NuGet feed to an alternate package source, like I've done here with AutoFac's nightly build feed:

![image][3]

The other thing is that once you get it installed in your system cache, it will resolve it from there, which I imagine makes it harder to triage for anyone trying to figure out what's going on.

I'm seeing various confirmations of this on Twitter:

![image][4]

![image][5]

With NuGet 3 being release (and part of VS 2015) I think some package authors are unsure if it's their problem or what the case may be. Depending on the method you come at it, it's possible that you can still get the package, but I would say it seems unpredictable right now.

[1]: https://twitter.com/BrockLAllen
[2]: http://jameschambers.com/wp-content/uploads/2015/07/image3.png "image"
[3]: http://jameschambers.com/wp-content/uploads/2015/07/image_thumb1.png "image"
[4]: http://jameschambers.com/wp-content/uploads/2015/07/image5.png "image"
[5]: http://jameschambers.com/wp-content/uploads/2015/07/image6.png "image"
  