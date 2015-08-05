# Western Devs Website

[![Build Status](https://travis-ci.org/westerndevs/western-devs-website.png)](https://travis-ci.org/westerndevs/western-devs-website)

The website for [WesternDevs](http://www.westerndevs.com)

Installing [Jekyll](http://jekyllrb.com/docs/installation/)

Instructions for running [Jekyll on Windows](http://jekyll-windows.juthilo.com/)

Run `bundle install` to start off.

Useful commands:

* `rake serve`: Serves up the website on your local machine (assuming Jekyll and Rake are installed). Will not show draft posts but links will be properly addressed for your local machine
* `rake serve["drafts"]`: Same as `rake serve` but includes draft posts
* `octopress new draft "Draft Title"`: Creates a new draft based on the specified title. You'll need to set the author and original URL.
* `octopress new post "Post Title"`: Same as the previous command except it creates a post
* `octopress publish moo`: Moves the post titled "moo" from _drafts to _posts. If there is more than one draft with "moo" in the title, it will give you a list to choose from.

Installing [Jekyll](http://jekyllrb.com/docs/installation/)

Instructions for running [Jekyll on Windows](http://jekyll-windows.juthilo.com/)

### Docker

We have created a Docker image to facilitate running on Windows (or other OSes) if you would rather not install all the dependencies required for Jekyll (e.g. Ruby, Python, Jekyll). To set up:

1. Install Docker
2. Clone the western-devs-website repository (see note below)
3. Open Oracle VM Virtual Box Manager
4. Right-click the boot2docker VM and select Settings...
5. Select the Network menu item on the left
6. In the Adapter 1 tab, click Port Forwarding
7. Add a new port forwarding rule that maps port 4000 in the guest to port 4000 in the host
8. Close the Virtual Box Manager
9. Launch Boot2Docker on Windows
10. Run: `docker run -t -p 4000:4000 -v //c/path/to/code:/root/jekyll abarylko/western-devs:v1 sh -c 'bundle install && rake serve'`

If you have trouble running the docker image, there may be permission issues. Clone the repository into your C:\Users\<yourusername> folder and try again.

Once the docker container is running `rake serve`, you can run the site locally in Windows at http://localhost:4000. You can make changes to posts and pages and after a delay of about 15 seconds, you can refresh your browser and see the changes.

### Setting up an Azure Testing Environment

If you don't want to go through the process of installing and configuring docker (above), there's a powershell script that will do all the work for you of setting up an Azure environment with Linux and docker installed, and deploy your branch so you can test it.

1. Install Azure Powershell if you don't already have it (the installer is in the _azure folder)
2. Run deploy.ps1 from the _azure folder (you'll be prompted for a few things including your branch name to deploy, and your azure credentials) - this takes about 10 mins
3. You can keep the Azure environment around to use for development/testing, or you can destroy it by deleting the Resource Group that is created via the Azure Portal (http://portal.azure.com)

### Creating Posts Manually using Markdown

Posts are generated from simple markdown files that are located in the _posts folder. Once the file has been committed to the `source` branch, a [Travis CI build](https://travis-ci.org/westerndevs/western-devs-website/) will kick off, transform the .markdown and then add it to the site. The build can fail if your .markdown file contains any errors.

Quick steps for creating a post are:  

1. Create a .markdown file while follow the naming convention of the files that are in the _post folder
2. Push the .markdown file into _posts directory in the source branch
3. Ensure the CI build completes successfully

More complete documentation can be found here: [Jekyll Docs](http://jekyllrb.com/docs/posts/)

#### Post Header
You need to put the following section, filled out appropriate, for all of the post styling to be applied.

1. There must be no space/lines above the header section's top ---
2. Make sure the title is included in "double quotes" to avoid conflicts with special characters (e.g. colons)
3. The --- at the top and bottom must be included

```
---
layout: post
title:  "Building a TFS 2015 PowerShell Module using Nuget"
date: 2015-07-23T17:30:00-06:00
categories:
comments: true
author: dave_white
originalurl: http://agileramblings.com/2015/07/23/building-a-tfs-2015-powershell-module-using-nuget/
---
```

**Note:** Avoid categories except in exceptional circumstances. Categories are used to build up URLs (e.g. http://westerndevs.com/c-sharp/repositories/nuget/tfs/my-post-about-nuget-and-tfs). We would like to avoid this but still use categories for other purposes (e.g. podcasts).


#### Code Syntax Highlighting

Syntax highlighting is done by Jekyll using [Pygments](http://pygments.org). In order to get syntax highlighting in a section, it needs to be wrapped as follows.

```
{% highlight powershell %}

... code goes here ...

{% endhighlight %}
```

Over 100 languages are supported. You can see the [list of supported languages here](http://pygments.org/languages/).

**Note:** You do not need to (and in fact, should not) indent The first line of your code snippets. The {% highlight %} tag is enough to signify a code snippet.
