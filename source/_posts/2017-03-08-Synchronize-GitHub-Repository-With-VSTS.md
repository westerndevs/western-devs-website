---
layout: post
title: Synchronize GitHub Repository with VSTS
tags:
  - devops
  - vsts
  - github
date: 2017-03-08 14:00:00
excerpt: Step by step guide to do an automated continuous one-way synchronization from a GitHub repository to a VSTS repository.
authorId: dylan_smith
---
A fellow Western Dev - Justin Self - was telling me he uses GitHub for source control and VSTS for Work Items, and was wondering if it's possible to link the Work Items to GitHub commits.  If you're using VSTS for source control, you can do this easily by mentioning the Work Item ID in your commit message like so: Fixing Bug #123.  And VSTS will automatically create a link between the Work Item and the Git commit.  If you're using GitHub for source control, I don't believe there's an out of the box way to make this work.

We came up with an idea, what if we could synchronize the GitHub repository to a VSTS repository.  Then VSTS could see the commits and create the WI links.  So that's what we did, and this blog post explains how you can do the same thing.

First things first, you need to create a VSTS Build that points to your GitHub repo.  That's easy enough, as support is built right into VSTS builds to do this.

	1. Go to Builds and Create a New Definition (Note: I'm using the new build editing experience - which you can turn on for your account if you haven't already).
	2. Choose the Empty Process option
	3. Configure the Get Sources task to use GitHub as the source, and give the connection a name
	4. Click Authorize using Oauth - at this step you may be prompted for your GitHub credentials and to Authorize VSTS to talk to GitHub
	5. Pick the GitHub repo and branch - I just left this as master, but later we will set it up to synch all branches
	6. Go to the Triggers tab and turn on Continuous Integration, and change the branch to include to * to trigger a build on commits/pushes to any branch
	7. Under Options turn on Allow Scripts to Access Oauth token - we'll use this later
	8. Save and Queue a build to check if it works
	
![New Build Definition](http://imgur.com/YzvjdpQ.png)

![Select Build Template](http://imgur.com/bnugm3O.png)

![Configure Source Repo](http://imgur.com/ms364Zw.png)

![GH Repo Configured](http://imgur.com/LSQDzg2.png)

![Configure CI](http://imgur.com/w8bYFxi.png)

![Configure OAuth](http://imgur.com/Z6Eei4O.png)

![Test Build Output](http://imgur.com/PxGFis0.png)

Alright, now we have a build that triggers on every GitHub commit/push, and will download the GH repo to the build agent.  The next step is to make it push any and all changes into the VSTS repo.  To do this I shamelessly copied a snippet of bash from StackOverflow.  There is a built-in build task to run a bash script - Shell Script - but that requires you to point it to a script inside your repo, which is more work than I wanted.  I just want to write the few lines of bash directly in the build.

![Default Shell Task](http://imgur.com/OQCpY7W.png)

Fortunately there is a VSTS extension in the marketplace that lets us do exactly this: https://marketplace.visualstudio.com/items?itemName=tsuyoshiushio.shell-exec

![Extension Shell Task](http://imgur.com/bSzWWig.png)

Once I installed that extension into my VSTS account, I can now add it as a task to my build and tell it the bash script I want it to run:

![Install Extension](http://imgur.com/C1tVW5x.png)

![Confirm Extension](http://imgur.com/SmKJlax.png)

![Extension Installed](http://imgur.com/R8zE0ss.png)

![Add New Task](http://imgur.com/wJZmhuE.png)

![Configure Shell Task](http://imgur.com/ErwFNbF.png)

Those 3 lines of bash using the git command-line are all it takes.  The one tricky bit to figure out was how to make sure it synchronized all branches - even newly created branches - in github into VSTS.  The trickery in line 1 and 3 does that.
{% codeblock lang:shell %}
git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
git remote add vsts https://pokerleaguemanager.visualstudio.com/DefaultCollection/_git/GitHubSync
git branch -r | grep -v '\->' | while read remote; do git -c http.extraheader="AUTHORIZATION: bearer $SYSTEM_ACCESSTOKEN" push -u vsts "${remote#origin/}"; done
{% endcodeblock %}

That script is doing a few things:
	1. Loop through all branches in origin and create local branches to track them. Note: Because GH was setup as the repo for this build, VSTS has already created the git repo, setup origin to point to GH, and downloaded the repo to the build agent.
	2. Add the VSTS repo as a new remote called vsts
	3. Loop through all branches and push each one to VSTS

The stuff with $SYSTEM_ACCESSTOKEN in line 3 is accessing an environment variable that contains an Oauth token that can be used to communicate with VSTS - in a previous step where we set the option in the VSTS build to make Oauth token available to scripts, is what allows this to work.

There's one thing left to do to make this all work - we need to grant the build service account access to the VSTS repo.  We can do this in the repo security screen like so:

![Configure Security](http://imgur.com/eCYpGEC.png)

Now you can push some commits to GitHub and/or create a new branch, and the VSTS build should automatically trigger and synch the VSTS repo up almost immediately.  If everything is working you should see build output that looks something like this:

![Successful Build Output](http://imgur.com/E3GhdJI.png)
