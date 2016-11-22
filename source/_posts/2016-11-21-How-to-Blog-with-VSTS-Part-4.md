---
layout: post
title: How to Blog with VSTS (Part 4)
categories:
  - alm
tags:
  - visual studio team services
  - vsts
  - alm
  - hexo
date: 2016-11-21 07:30:00
updated: 2016-11-21 07:30:00
excerpt: I wanted to understand how to use Visual Studio Team Services (VSTS) for a "real" project. Being a noob, I decided to move my blog to VSTS to understand how _any_ project can benefit from ALM practices using VSTS. In part 4 of 5, we setup a _Build_ script.
authorId: david_wesst
---

_This is part 4 of 5 of my **How to Blog with VSTS** series. Links to the other parts will be added as they are made available._

+ [Part 1: Setup][1]
+ [Part 2: Code][2] 
+ [Part 3: Work][3]
+ [Part 4: Build][4]
+ Part 5: Release

[1]: https://blog.davidwesst.com/2016/10/How-to-Blog-with-VSTS-Part-1/
[2]: https://blog.davidwesst.com/2016/11/How-to-Blog-with-VSTS-Part-2/
[3]: https://blog.davidwesst.com/2016/11/How-to-Blog-with-VSTS-Part-3/
[4]: https://blog.davidwesst.com/2016/11/How-to-Blog-with-VSTS-Part-4/
[5]: #

---

I've been tinkering with Visual Studio Team Services off and on since its public release, but never did anything really productive with it. Over the past couple of weeks, I finally bit the bullet and decided to move my most prevelant personal project into VSTS: this blog.

In this post we are we going to create a build script in VSTS so we can generate our blog content consistently and get it ready to deploy somewhere.

## Creating Our Build Script
First, we need to navigate over to the _Build_ section of VSTS, which you can find in the navigation menu at the top of the page.

<!-- image of build menu item -->
![Build and Releases Menu](http://i.imgur.com/7S55XWDl.png)

This is where we're going to create our build script by hitting the "Create New Build" button.

<!-- image of new build button -->
![New Build Button](http://i.imgur.com/6uCoEEFl.png)

## Adding Build Tasks (Hexo Edition)
VSTS provides plenty of build tasks. Statically generated sites will have different build tasks, so I'm going to walk you through the build tasks I setup for [Hexo](https://hexo.io/).

It's pretty straight forward, but it helps to list them out in order.

1. Install global npm dependencies
2. Install local npm dependencies
3. Other stuff that needs doing
4. Generate site content
5. Store site content as build asset OR Deploy!

Let's go through these.

### npm Global Dependencies
In this case, I only have one which is `hexo-cli` so that I can run the `hexo generate` command later on in our build. 

You could add it's own npm task here, by adding a new task and setting the parameters of the task accordingly.

<!-- npm install -g task -->
![npm task](http://i.imgur.com/h1HFRAJl.png)

Personally, I don't have a separate task. I use my project's `package.json` and set a [_preinstall_ script](https://docs.npmjs.com/misc/scripts) which gets run before the `npm install` command.

Either one works really. I just like having my source code setup be as simple as `npm install` and then `npm start` to run the site.

### npm Local Dependencies
Just like the previous, except this time we're using the default parameters. We just need the build to run `npm install` and let it do it's thing.

### Other Stuff
Every project is a unique snowflake, and sometimes you have some extra tasks you need accomplished. In my case, I have a custom theme that I build every time. To accomplish this, I have a PowerShell script in the `\tools` directory of my source code that gets run every time.

<!-- powershell task with parameters -->
![PowerShell Task with Parameters](http://i.imgur.com/aXmLKcml.png)

#### CMD, Powershell, and Bash Tasks
You're not limited to just PowerShell, but you can have CMD or even bash shell scripts executed. The only caveat of running these is making sure that the build server being used to run your build has these capabilities.

If you're using the hosted server, like I do, then PowerShell and CMD are your best bets. I did try to have both PowerShell and Bash, which resulted in getting a message saying I "didn't have a host that had these capabilities".

Maybe in time we'll have hosted servers that do both, but until then you'll need to setup your own server to handle these unique dependencies or try can conform your code to use one or the other.

#### Keeping it Open Source
If you're looking to keep your source open on, you'll likely want to push it out of VSTS and into GitHub or somewhere where the public can get their hands and eyes on it.    

This is the job for another script task. In my case, I followed [this blog post](https://nkdagility.com/open-source-vsts-tfs-github-better-devops/) that [Dylan Smith](http://www.westerndevs.com/bios/dylan_smith/) directed me to and followed along.

### Generate Content
Again, another script task. But this one is easier, as we're just running `hexo generate`. 

You could write a whole script file for this too, but I opted to make it simple and just configure the build task itself.

<!-- hexo generate build task -->
![hexo generate build task](http://i.imgur.com/dGWjUTNl.png)

### Save and Publish Site Content
We'll discuss this further when we get to [releases][5] but we need to save our content assets so we can publish them later. For hexo, this is usually the contents of the `public` folder.

To handle this, I use the _Copy and Publish Build Assets_ task and configure it to save the contents of the `public` folder so that it persists after the build is complete.

<!-- publish assets task -->
![Copy and Publish Build Assets](http://i.imgur.com/LJTk1wKl.png)

#### ...or Deploy!
Another option is to just deploy it directly from the build script and skip the whole [release management][5] component. This would allow you do a deployment everytime you build, making sure the latest source code is live.

Again, it's a matter of preference. The reason I like [releases][5] over this model is to be able to manage the release of source code independenly of the build itself. 

## Triggering the Build
I have two build scripts that are almost identical. One that I use for development and continuous integration. The other is scheduled to prepare a for a weekly release of my blog.

VSTS accomodates both of these options, which you can see in the _Triggers_ tab of the build script.

<!-- image of the triggers tab -->
![Triggers Tab](http://i.imgur.com/YHlzH7Cl.png)

For my development build script, I trigger the build on pushes to the `master` branch of my repository. I have also configured this build script to run on a private build agent that I have setup.

I won't be covering private build agents in this series of posts, but I assure you it's very easy. I setup my development machine as a private build server, and had it setup in about 15 minutes after following [these instructions](https://www.visualstudio.com/en-us/docs/build/admin/agents/v2-windows).

## Next Up: Releases!
We're almost done, and technically you don't need the next step if you just want to do continual deployment and have a deployment step in your build script. That being said, I like having the release pipeline as it gives me a few other things to ensure my blogging goes out without a hitch.

More on that [next time][5].
