---
layout: post
title:  "Converting .NET 4.6 Projects to the VS 2015 Project System"
date: 2015-08-13T23:22:51+02:00
categories:
comments: true
authorId: james_chambers
originalurl: http://jameschambers.com/2015/08/converting-net-4-6-projects-to-the-vs-2015-project-system/
alias: /converting-net-4-6-projects-to-the-vs-2015-project-system/
---

To take advantage of multi-targeted outputs from our project – allowing our assemblies to be used from multiple frameworks across the organization – we want to upgrade our projects to use the new project system in Visual Studio 2015. Previously, we would have needed a base project and then a separate project for each framework target (PCL, 4.5, 3.5, 4.5.2, etc), but in today's solutions we can have a single project output all of the assets we wish to support.

<!--more-->

>_In this series we're working through the conversion of [Clear Measure's][1] [Bootcamp MVC][2] 5-based application and migrating it to MVC 6. You can track the entire series of posts from the [intro page][3]._

## Recreating the Solution and Projects

As of right now, there are no tools in place that would support an in-place migration from the old project system to the new one. Because we wanted to preserve project naming and namespaces, I copied everything out into a new directory – the solution and the projects – and rebuilt the solution from scratch.

I would anticipate a project conversion process at some point, even one that was able to provide the basics (like moving package dependencies to project.json) and guidance on the remaining pieces (like why part of the project wasn't able to convert, and how you might approach it). This post will walk through those steps of the conversion, but it will be done manually.

I wanted to maintain all the same names of the assemblies, namespaces and outputs, and the only way to currently do this is to clear out the src folder and start over. Don't worry, our code is still good, we just have to wrangle it into new containers.

## Step 0: Folder Reorganization

One of the first changes that I made was a reorganization of the tooling that is used to support the build. Some of the build script relied on packages existing on disk (NUnit's console runner, AliaSql) but this is an order-of-operations problem. When you grab the solution from the repo, you're not actually able to build it until you restore the packages. Further, these assets are **solution-level **concerns, not project-level concerns, so which project do you install them into? NuGet does not have the concept of solution-level packages that apply to the solution itself, so while it works perfectly well for projects, NuGet is inherently not ideal for incorporating solution dependencies.

To remedy this, I have moved these types of assets into a tools folder and updated the build scripts accordingly. This approach is likely a matter of opinion more than anything, but the reality is that we want the directory structure to reflect which concerns **_are in_** the solution versus which concerns **_work on_** the solution.

I would like to note that there are still improvements to be made here – for instance, I know many teams actually have build scripts that are capable of not only restoring packages, but have the ability to go and grab NuGet itself – so expect some more changes as we continue to move through this migration. Automation is _awesome_.

## Step 1 – Core

{% img pull-right "http://jameschambers.com/wp-content/uploads/2015/08/image_thumb.png" %}

Our Core project was a breeze to port because it's at the heart of the system in an [Onion Architecture][5] and takes on very few dependencies. I started the conversion by going through the motions of creating a new Core project, using the DLL project from the "Web Templates" part of the dialog.&nbsp; The first project also creates the solution, and the convention for the way the solutions are laid out on disk has changed.

So…the build broke.

Thankfully, this was easy to resolve with just a couple of quick fixes, but you'll likely have to take similar steps on your project:

* First, update your paths to point at the correct location on disk
* Second, comment out all the build steps that have to come later, like running unit or integration tests

{% img pull-right "http://jameschambers.com/wp-content/uploads/2015/08/image_thumb1.png" %}

We can't run unit tests quite yet (we need to convert those projects as well), but we can make sure that the project is building correctly.

We're not modifying code at this point, so provided we can get the solution building we can have a good level of confidence – but not a guarantee – that our code is still in good shape. We want those tests back online before we merge this branch back to develop.

With the build running, I was able to jump back into Visual Studio and start adding back the code. In my case, nearly everything worked just by copying in the files from my backup location and pasting them into the project. It's a bit tedious, but it's by no means difficult or complicated.

The only package that I had to add at this point was a legacy dependency from NHibernate, namely the Iesi.Collections package. This is done by opening up the project.json for Core and updating the "dependencies" part of the project file. As soon as you save the file out, Visual Studio goes off and runs a background install of the packages that it finds you've put in there, along with any dependencies of those packages.

![image][7]

Finding the right package and most recent version is quite easy in the project.json world. As you start typing a package name, in-line search kicks in and starts suggesting matches. Available versions of the packages are displayed, and VS indicates if those packages are available locally in a cache or found on a remote NuGet repository, indicated by the icon you see. All packages sources are queried for package information, so you can get packages and their version information from private repositories as well.

Once the packages were restored the solution built fine in Visual Studio 2015 and I was able to return to my console to run the build script.

![image][8]

## Step 2: Data Access

Other than the fact that Data Access has a few more dependencies, it was really more of the same to get the Data Access project online and building through our script. I added another DLL to the solution, added the source files and installed the dependencies via project.json.

When I compiled the project at this point, some of the changes of the .NET Framework and the strategy of the team started to surface. For instance, typically you might find a reference to System.Data from your GAC in a project, however, in the new cross-platform project system and under the assumption that you may not have a GAC at all, the .NET folks have taken the mantra of "NuGet all the things." To get access to the System.Data namespace and the IDataReader interface that was used in the DataAccess project, I had to add a reference to System.Data version 4.0.0 from NuGet (via project.json).

Other projects will have similar hits on moved packages. It is likely safe to use the GAC in situations where you know what the build environment looks like and are sure that build agents and other developers will have access to the required dependencies. But it is a more stable approach – and a better chance to successful compile our application – to instead reference those binaries from a package repository.

The other notable piece was in how we reference other projects in our own solution; today they look a lot like referencing other packages. Whether you go through the Add Reference dialog or if you prefer to edit the project file by hand, you're going to also need to introduce a dependency on Core, which is done simply by adding the following line to the dependencies:

<div class="notice">

    "Core": "1.0.0-*"

</div>

Excellent! Almost ready to build!

## Step 3: Clean Up

Just a couple of other notes that I took and a couple of tips I've learned as I created these projects:

* You'll have to set the default namespaces so that new classes that are introduced adhere to your conventions
* You need to enable the "Produce outputs on build" in order for your project to build a NuGet package (this is in the build options)

You're also in charge of wiring up any dependencies your modules need where they aren't satisfied with a single package for all output types. For instance, when I tried a small gamut of output targets I ran into this problem:

![image][9]

The new .NET Platform (the base for Windows, web, mobile and x-plat) was not supported given the dependencies I have listed in my project, namely it is the IESI Collections that is the problem here. Ideally, you want to be able to support as many runtimes as possible, so you want to target the lowest common denominator. That is likely going to be "dotnet" going forward (which could in turn be used to build up applications for web, Windows or phone) but more realistically things like "net46", which is just the 4.6 version of .NET, or "dnx46", which is the new bits (think MVC Framework) running on top of .NET 4.6. In the cases where you don't have a package that matches the target you need, you have a couple of choices, listed in order of easiest to most difficult:

* Contact the package authors to see if there is a new version coming
* If it's open source, contribute and get an output built for dotnet
* Add runtime-specific dependencies to get the project building, then use compiler switches to implement different blocks of code based on the target framework
* Switch off of that version of the package, or switch to an alternate package to get the same functionality and then update your code as required

Sadly, that last one is likely the way we're going to need to go, especially if we want to target x-plat development. This is not an easy task, but getting to this point in the migration is and only takes a couple of hours. If you haven't done this sanity check in your project to identify packages that may cause issues during migrations, I would suggest that your assessment is not complete.

For the time being, we are concerned about supporting .NET 4.6 and DNX running on 4.6 for our project, so that is where I have left things. This is a reasonable compromise allowing continued development in web and Windows.

## Moving On

The main tenets of our application are now alive and kicking in our Visual Studio 2015 solution with the new project system in place. In the next post in this series we'll have a look at getting the tests online and updating the build script to execute our tests.

If you'd like to follow along with the progression as we get this fully converted you can check out [the branch on GitHub][10].

Happy coding! ![Smile][11]

[1]: http://clear-measure.com/
[2]: https://github.com/ClearMeasureLabs/ClearMeasureBootcamp/
[3]: http://jameschambers.com/2015/07/upgrading-a-real-world-mvc-5-application-to-mvc-6/
[4]: http://jameschambers.com/wp-content/uploads/2015/08/image_thumb.png "image"
[5]: jeffreypalermo.com/blog/the-onion-architecture-part-1/
[6]: http://jameschambers.com/wp-content/uploads/2015/08/image_thumb1.png "image"
[7]: http://jameschambers.com/wp-content/uploads/2015/08/image2.png "image"
[8]: http://jameschambers.com/wp-content/uploads/2015/08/image3.png "image"
[9]: http://jameschambers.com/wp-content/uploads/2015/08/image4.png "image"
[10]: https://github.com/ClearMeasureLabs/ClearMeasureBootcamp/tree/refactor/move-to46-with-multitargetting
[11]: http://jameschambers.com/wp-content/uploads/2015/08/wlEmoticon-smile.png
  