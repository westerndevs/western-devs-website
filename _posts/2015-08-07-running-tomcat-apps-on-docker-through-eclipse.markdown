---
layout: post
title: "Running Tomcat Apps on Docker through Eclipse"
date: 2015-08-07 12:55:40
categories:
comments: true
author: david_wesst
originalurl: http://blog.davidwesst.com/2015/08/Running-Tomcat-Apps-on-Docker-through-Eclipse/
---
If you didn't already know, [Docker](https://www.docker.com) is pretty cool. Not sure what it is? My fellow Western Dev [Kyle Baley](http://www.westerndevs.com/docker-is-coming-whether-you-like-it-or-not/) explains it really well and provides some great cases about why Docker is fantastic.

This post is an example of Docker being fantastic and should be considered a warm-up to Docker.

Although I'm talking Tomcat and Eclipse, this idea can be used with pretty much any combination of technologies available through Docker and your development environment of choice.

## Context
When I dive into the code, I don't want to have to worry about running some version of Tomcat on my development machine.

Docker can solve that.

I also don't like obscuring part of my solution through _IDE Magic_, such that when I run my Tomcat application I want to know how it's running. In fact, not only do I want to know _how_ it runs, but I want the steps to run the application to be automated so I don't have to think about it. I know Eclipse can do this natively, but because I'm not looking to run Tomcat on my machine, it adds some challenges.

Here's what I did.

## Solution
The solution is a simple one, but it works consistently. Plus, we'll even integrate it with Eclipse so people that don't like leaving their IDE can continue to code in in their comfort zone.

I am assuming that you...
+ ...are running Windows
+ ...have a Maven web app project
+ ...have setup Boot2Docker
+ ...have a linux-flavoured shell (like Git Bash)

Maven gives us a standard structure for our project. More specifically, it packages everything up into the ```/target``` directory so that we can map the volume to our docker image.

Now, let's make this run every time.

### The Start Script
The first script I created just packages things up, makes sure boot2docker is running, and runs docker.

Being that I run the script from the project root, it looks like this:

{% highlight Bash Session %}
#!/bin/bash

# package the WAR file
mvn package

# Make sure docker instance is running
boot2docker up

# Run the application
docker run --rm -p 8080:8080 -v //./target/mywebapp:/usr/local/tomcat/webapps/mywebapp tomcat:6.0
{% endhighlight %}

### The Stop Script
Thanks to the power of Bingoogle, I was able to find [this](https://coderwall.com/p/ewk0mq/stop-remove-all-docker-containers).

{% highlight Bash Session %}
docker stop $(docker ps -a -q)
{% endhighlight %}

And there are my scripts to start and stop my application. The main reason for creating these is to make sure that anyone pulling down the solution can be productive. Even those that like staying inside of Eclipse all the time.

### Integrating with Eclipse
Because we have these scripts, we can setup a couple of "External Tools" to start and stop at the push of a button.

![](http://blog.davidwesst.com/2015/08/Running-Tomcat-Apps-on-Docker-through-Eclipse/1-externaltoolsbutton.png)

To set it up, click the button or the drop down and select "External Tools Configuration", then setup a couple of programs where you call sh.exe (provided with Git Bash) and our new scripts as the arguments.

![](http://blog.davidwesst.com/2015/08/Running-Tomcat-Apps-on-Docker-through-Eclipse/2-configwindow.png)

Now everybody can start and stop at their leisure. Plus, if we need to add more complexity to starting and stopping, we can just extend the scripts.

### Alternatively...Make a Dockerfile
That being said, we could also customize our docker image to include files right on the image rather than mapping volumes. Although this doesn't add any value to this example, it might later on if we want to start customizing our Tomcat server to include multiple files or other libraries that our application will need.

**FUN FACT:** Copying the files over to the image means that you can't do any debugging on them in your environment right away, as opposed to if you were to map the files locally. Not a big deal in some cases, but I like to keep all the doors open for debugging.

Here's an example, but you can get the full scoop on dockerfiles [here](https://docs.docker.com/articles/dockerfile_best-practices/):

{% highlight Bash Session %}
FROM tomcat:6.0
MAINTAINER David Wesst <questions@davidwesst.com>

# add our WAR files
ADD target/\*.war /usr/local/tomcat/webapps/
{% endhighlight %}

Then we need to update our ```start-docker.sh``` file from above to build the new image so we can run it.

{% highlight Bash Session %}
#!/bin/bash

# package the WAR file
mvn package

# Make sure docker instance is running
boot2docker up

# Build a new docker image
docker build -t davidwesst/tomcatsample:dev .

# Run the application
docker run --rm -p 8080:8080 umanitoba/tomcatsample:dev
{% endhighlight %}

### The Point
This is a pretty straightforward example on how to use docker, and how to tie it into any processes or IDEs that you may have. I know that [Eclipse Mars has functionality for docker](http://www.eclipse.org/community/eclipse_newsletter/2015/june/article3.php), but sometimes we don't get to use the shiny new toy and need to stick with the old realiable ones. This solution works with Eclipse Luna, and below from what I can gather, so people that are stuck using older IDEs can still enjoy Docker.

...but you should really get comfortable with the command line and [Learn to be IDE Free (Shameless Self Promotion)](http://blog.davidwesst.com/talks/).

--
Thanks for Playing
~ DW
