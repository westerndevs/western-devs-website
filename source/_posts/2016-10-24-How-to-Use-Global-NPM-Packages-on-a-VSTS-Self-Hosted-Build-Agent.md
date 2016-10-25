---
layout: post
title: How to Use Global NPM Packages on a VSTS Self-Hosted Build Agent
date: 2016-10-24 08:33:01
tags:
  - javascript
  - visual studio team services
  - nodejs
  - npm
categories:
  - development
excerpt: I setup a self-hosted build agent in Visual Studio Team Services. My build installed global NPM packages, but the tasks that used them later on in the script would fail because they were unable to use them. This post describes what I did to get them working.
authorId: david_wesst
originalurl: https://blog.davidwesst.com/2016/10/How-to-Use-Global-NPM-Packages-on-a-VSTS-Self-Hosted-Build-Agent/
---

I took a couple of weeks off of blogging to focus on a building my presentation for [Deliver](http://www.prdcdeliver.com/). In my spare time, I started tinkering with Visual Studio Team Services, where decided to start by automating the build and release of this blog.

My build script is pretty straight forward. Setup the global dependencies with NPM, setup the local dependencies with NPM, generate the content, and publish the generated assets. This worked in my hosted agent, but not my self-hosted agent.

I found a few solutions, but I'll go through the one I selected for my build agent.

### The Problem
My build script would run `npm install --global hexo-cli` and execute as expected. When the next step would try and use the `hexo generate` command, I would get the following error:

```
##[error]hexo : The term 'hexo' is not recognized as the name of a cmdlet, function, script file, or operable program. Check 
the spelling of the name, or if a path was included, verify that the path is correct and try again.
```

Even though the install command was successful, the build script still couldn't use the tool installed.

Another symptom of this problem is that Team Services can't see global NPM packages as common capabilities, such as Bower, Gulp, and Grunt.

!["Gulp and Grunt as capabilities"](http://i.imgur.com/pkLEzkEl.png)

I setup my build agent to use the NetworkService user account, but it could be setup for any user. The problem is that the NetworkService account can't see the global packages on the machine after they are installed. The solution is to configure NPM to point to a folder that is visible to the NetworkService account.

Here's how you do it.

### The Solution
I found [this solution on StackOverflow](http://stackoverflow.com/questions/38570209/making-global-npm-packages-available-to-all-users-on-windows-2012-server) which lead me in the right direction, although I didn't follow all of it.

The [`npm prefix -g`](https://docs.npmjs.com/cli/prefix) command shows us path to global prefix folder, where the global npm packages are stored. We need to point this to a directory that NetworkService can read and execute. Generally speaking, the prefix folder is usually found in the user's AppData folder.

To change the prefix, run the command `npm config set prefix C:\\Path\\To\\Folder\\AppData\\Roaming\\npm` which will change the npm prefix folder to be the one specified. Because I've set my build agent NetworkService account, I point it at the NetworkService account AppData npm folder for simplicity.

Then add the folder to the PATH variable for the machine. This will let VSTS see the npm packages as capabilities so that it knows that our build server can execute Grunt, Gulp, and Bower tasks.

#### Why Didn't You Reset the Prefix?
It makes sense to reset the prefix to the previous value after the build has complete, as described in the StackOverflow solution. In my case, I wanted to make sure that if someone were logging into the build server to add another global package, let's say something like Hexo CLI, then it would be installed in the appropriate directory.

I didn't reset the prefix because I wanted to permanently configure the build agent. It's a small build server that I'm using to experiment with continuous integration and deployment. If it's good enough for StackOverflow then it's good enough for me.

## A Few Alternative Solutions
As an alternative solution you could setup a new directory that isn't the AppData folder, add the new folder to the PATH, and then point the prefix folder at build time. You could also leverage the `npm bin` setting and setup alias in your package.json file for the global commands you're looking to use (Thanks to [Aaron Powell](http://www.aaron-powell.com/) for providing me with that one), which is another good solution that I'll revisit if I use something other than VSTS for builds.