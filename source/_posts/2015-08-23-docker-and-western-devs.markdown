---
layout: post
title:  "Docker on Western Devs"
date: 2015-08-23T16:38:59-04:00
categories:
comments: true
author: kyle_baley
---

In a month, I'll be attempting to hound my share of glory at [MeasureUP](http://measureup.io) with a talk on using Docker for people who may not think it impacts them. In it, I'll demonstrate some uses of Docker today in a .NET application. As I prepare for this talk, there's one thing we [Western Devs](http://www.westerndevs.com) have forgotten to talk about. Namely, some of us are already using Docker regularly just to post on the site.

Western Devs uses Jekyll. Someone suggested it, I tried it, it worked well, decision was done. Except that it doesn't work well on Windows. It's not officially supported on the platform and while there's a [good guide](http://jekyll-windows.juthilo.com/) on getting it running, we haven't been able to do so ourselves. Some issue with a gem we're using and Nokogiri and lib2xml and some such nonsense.

So in an effort to streamline things, [Amir Barylko](http://www.westerndevs.com/bios/amir_barylko/) create a [Docker image](https://github.com/westerndevs/western-devs-website/blob/source/Dockerfile). It's based on the Ruby base image (version 2.2). After grabbing the base image, it will:

* Install some packages for building Ruby
* Install the bundler gem
* Clone the source code into the /root/jekyll folder
* Run `bundle install`
* Expose port 4000, the default port for running Jekyll

With this in place, Windows users can run the website locally without having to install Ruby, Python, or Jekyll. The command to launch the container is:

`docker run -t -p 4000:4000 -v //c/path/to/code:/root/jekyll abarylko/western-devs:v1 sh -c 'bundle install && rake serve'`

This will:

* create a container based on the `abarylko/western-devs:v1` image
* export port 4000 to the host VM
* map the path to the source code on your machine to /root/jekyll in the container
* run `bundle install && rake serve` to update gems and launch Jekyll in the container

To make this work 100%, you also need to expose port 4000 in VirtualBox so that it's visible from the VM to the host. Also, I've had trouble getting a container working with my local source located anywhere except C:\Users\\*mysuername*. There's a permission issue somewhere in there where the container appears to successfully map the drive but can't actually see the contents of the folder. This manifests itself in an error message that says `Gemfile not found`.

Now, Windows users can navigate to localhost:4000 and see the site running locally. Furthermore, they can add and make changes to their posts, save them, and the changes will get reflected in the browser. Eventually, that is. I've noticed a 10-15 second delay between the time you press Save to the time when the changes actually get reflected. Haven't determined a root cause for this yet. Maybe we just need to soup up the VM.

So far, this has been working reasonably well for us. To the point, where fellow Western Dev, [Dylan Smith](http://www.westerndevs.com/bios/dylan_smith/) has automated the deployment of the image to Azure via [a Powershell script](https://github.com/westerndevs/western-devs-website/tree/source/_azure). That will be the subject of a separate post. Which will give me time to figure out how the thing works.