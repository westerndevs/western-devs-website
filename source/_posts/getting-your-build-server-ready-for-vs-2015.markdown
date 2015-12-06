---
layout: post
title:  "Getting Your Build Server Ready for VS 2015"
date: 2015-07-24T10:22:30-04:00
categories:
comments: true
authorId: james_chambers
originalurl: http://jameschambers.com/2015/07/getting-your-build-server-ready-for-vs-2015/
---

If you're modernizing your project, one of the things you'll surely want to do is to make sure that your build server is upgraded to support VS 2015. Regardless of what CI engine you're using, there will be at least a little bit of effort required to get your project building again.

>In this series we're working through the conversion of an MVC 5-based application and migrating it to MVC 6. You can track the entire series of posts from the [_intro page_][1].

For the purpose of this exercise, we're using TeamCity to run our builds based on a VSC checkin. We'll get TeamCity prepped to run our build and then update our repository so that we show our build status indicator on the readme home page.

## The TL;DR Details

Here's the basics of what was required to get the builds back online:

* Backup and upgrade TeamCity
* Allow the agents to upgrade, or upgrade them manually
* Install .NET 4.6 and the VS 2015 tools
* Ensure that build targets live on your build agents
* Run your build

## Upgrading the Server

I engaged my teammate [James Allen][2] here to help with some best practices, namely getting the server backed up. You can either back up the TeamCity data from the web interface or one of the other [recommended approaches][3], or you could snapshot your server for a reset should one be required. During this process, it's a good idea to spin down your build agents so that you're not wrecking anyone's builds.

Next, we needed to move to version 9.1 of TeamCity, so we ran the [upgrade process][4] via the web site. This is a painless task and takes only a fraction of the time it took to back up the data. Failing any troubles (we saw none), your build server should be back online in no time, and the build agents were notified (and complied!) to update themselves as well.

<img width="240" height="191" title="image" align="right" style="margin: 0px 0px 0px 10px; border: 0px currentcolor; border-image: none; float: right; display: inline; background-image: none;" alt="image" src="http://jameschambers.com/wp-content/uploads/2015/07/image_thumb5.png" border="0" scale="0">Next, I downloaded and installed the .NET 4.6 installer and the VS 2015 tooling, which can be found on the [VS 2015 download page][6]. You'll need to explore through the available downloads on the page, as you can see on this screenshot, to grab the relevant files.

These installs will need to be run on every build agent.

One thing to note was that my original attempt to get the build running failed because of missing build targets at an expected location. I ended up having to copy files from my local machine, where Visual Studio 2015 is installed, from the path: C:Program Files (x86)MSBuildMicrosoftVisualStudiov14.0 on the build server.

>I don't believe this is the best approach to getting the build targets on the build server. I will update this post if I find a better solution.

## Verifying the Install

You'll know the tools have been installed correctly if you return to the build configuration settings and add a new build step for msbuild (you don't have to save it). You'll see that you'll have the new options in place:

![image][7]

The build server should be good to go now! For us, we're not using an MSBuild build runner, our application is build with a PowerShell script via a batch file. This allows our build to be executed locally with only a small parameter change, and the CI process is entirely encapsulated in code (and under source control).

Provided your project is pointing at the repository, you'll have a good shot at running the build at this point. For our project, everything worked as expected.

![image][8]

## Showing Some Bling

Now it's time to beef up our repo, at least a little. What I'm talking about is wearing our CI on our sleeve, letting everyone on the team (or other watchers of the repository) that our builds are healthy or, perhaps, needing some love; let's display the build status indicator on our readme, like this:

![image][9]

First, drill into the build configuration and locate the advanced options under "General Settings". You need to enable the status widget.

![image][10]

Also, from this screen, take note of your Build Configuration ID. This is important because you'll need to include it in the server request to generate the badge.

Finally, include the following markdown, which is essentially a formatted link with an image inside of it:

    Current Build Status [![](http://YOUR_SERVER/app/rest/builds/buildType:(id:YOUR_BUILD_CONFIGURATION_ID)/statusIcon)](http://teamcity/viewType.html?buildTypeId=btN&guest=1)

Be sure to replace the obvious placeholder tokens with your own information.

## Next Steps

With our build server updated and our builds back online, it's time to start shifting our targets. In the next post, we're going to update our projects and recover from any errors/challenges we may discover along the way.

Happy coding! ![Smile][11]

[1]: http://jameschambers.com/2015/07/upgrading-a-real-world-mvc-5-application-to-mvc-6/
[2]: http://www.clear-measure.com/our-team/
[3]: https://confluence.jetbrains.com/display/TCD9/TeamCity+Data+Backup
[4]: https://confluence.jetbrains.com/display/TCD9/Upgrade
[5]: http://jameschambers.com/wp-content/uploads/2015/07/image_thumb5.png "image"
[6]: https://www.visualstudio.com/downloads/download-visual-studio-vs
[7]: http://jameschambers.com/wp-content/uploads/2015/07/image14.png "image"
[8]: http://jameschambers.com/wp-content/uploads/2015/07/image15.png "image"
[9]: http://jameschambers.com/wp-content/uploads/2015/07/image16.png "image"
[10]: http://jameschambers.com/wp-content/uploads/2015/07/image17.png "image"
[11]: http://jameschambers.com/wp-content/uploads/2015/07/wlEmoticon-smile3.png
  