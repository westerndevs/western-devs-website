---
layout: post
title:  Layer Already Being Pulled by Another Client. Waiting.
date: 2015-10-12T21:23:33-06:00
categories:
comments: true
authorId: simon_timms
originalurl:
---

I've been seeing a lot of this frustrating error when working with docker today. It turns out that pressing ^C when docker is downloading layers is not a good thing. In my case I changed hotspots which broke the download so I hit ^C. There are a couple of issues on github, [here](https://github.com/docker/docker/issues/15603) and [here](https://github.com/docker/docker/issues/3115) but basically nobody cares that the docker experience in this scenario is crummy. If you encounter this error it seems the only way to solve it is to restart the machine on which docker is running. If you're running docker against a VM then restarting the machine seems to fix it. 

<!--more-->
  
```
docker-machine ls
docker-machine restart default
```

If you're running against actual hardware then I guess you're going to have to press the power button. 

The cause appears to be that docker continues to download the package in the background but there is no way to surface that information to the client. I hope this is something that is fixed soon. 