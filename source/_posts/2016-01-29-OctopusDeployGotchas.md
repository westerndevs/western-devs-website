---
title: Octopus Deploy Gotchas: 400 Error and Can't Create File When It Exists
layout: post
tags:
  - Octopus
  - TFS
  - TFS Build
  - OctopusDeploy
categories:
  - News
authorId: darcy_lussier
excerpt: "Lessons from setting up a successful Octopus deployment."
---

I came across two isues with setting up a deployment with TFS and Octopus that seem pretty common based on my web searches. I wanted to document the root causes and the solutions I used to get around them.

##400 Error##

I began seeing 400 - Bad Request error messages when queueing up a build in TFS. The weird thing is that a build done seconds before was fine, but any subsequent build after that would throw the 400.

The reason for this is because the NuGet package being pushed had the same identifier as the previous NuGet package. To avoid this, you can do a few things:

1. Manually set the version number.
2. Write some script that will set the package version number.
3. Enable auto-incrementing on your project's asembly info.

I did #3. This is as simple as going into the AssemblyInfo.cs file of any project that will be deployed as part of the build and changing the AssemblyVersion value to..

[assembly: AssemblyVersion("1.0.*")]

OctoPack will automagically take the automatically incremented assembly version and use that for creating the NuGet package version number. The caveat here is that you must ***change code*** for this to work - by that I mean change a code file in your project which will trigger the assembly version to be incremented when a new build kicks off. For web projects, remember that ***HTML files don't get compiled*** so adding a line break in one of your views won't help because those don't get compiled and ergo don't trigger the assembly version increment.

This is not the ideal way to deal with this; its a stop gap. I shouldn't have to change a code file just to push new web files or images or whatever. I'm looking at how to implement a better solution, but for now this does work.

Also while there is docmentation that says adding "?replace=true" to your OctoPackPublishPackageToHttp MSBuild argument will force a NuGet package to deploy regardless if its the same version, I couldn't get that working. I have an email in to Octopus support and I'll update this post if I get it figured out.

##Cannot Create a File When It Already Exists##

Once Octopus does the deployment, you may see this error:

***Web site is stopped. Attempting to start...***

***start-webitem : Cannot create a file when that file already exists***

In my case, my deployments were completed when I manually checked them but this error forced all my deployments to show as having errored out and unsuccessful.

This issue seems to happen if you're deploying to a virtual directory in IIS and you're not using the "IIS6+ Home Directory" feature.

In Octopus select a project, click on Process, then click on the package you have set to deploy to IIS. Click on ***Configure Features*** (it's a hyperlink found closer to the bottom of the page. It's not obvious, so even doing a text search for it on the page can be a help).

This will bring up a dialogue of Enabled Features. Here you want to ***deselect the "IIS Web Site and Application Pool"*** and instead ***select "IIS6+ Home Directory"***. Now part of your step will have an area to specify a site/virtualdirectory path. You can only have one of the IIS-related features enabled at a time so make sure you uncheck "IIS Web Site and Application Pool" feature if its checked.

On a side note, but hand-in-hand with typical virtual directory deployments, if you need to have your app deployed in a specific spot (read: your virtual directory points to a folder outside of IIS) then also enable the Custom Install Directory option in Configuration Features; this will let you specify which folder the package contents should be deployed to.







