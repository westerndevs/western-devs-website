---
layout: post
title:  Yet Another Docker Intro on OSX
date: 2015-10-04T23:32:11-06:00
categories: docker
comments: true
authorId: simon_timms
originalurl: http://blog.simontimms.com/2015/10/04/yet-another-docker-intro/
---

You would think that there were enough introductions to Docker out there already to convince me that the topic is well covered and unnecessary. Unfortunately the sickening mix of hubris and stubbornness that endears me so to rodents also makes me believe I can contribute. 

In my case I want to play a bit with the ELK stack: that's Elasticsearch, Logstash and Kibana. I could install these all directly on the macbook that is my primary machine but I actually already have a copy of Elasticsearch installed and I don't want to polute my existing environment. Thus the very 2015 solution that is docker. If you've missed hearing the noise about docker over the last year then you're in for a treat. 

The story of docker is the story of isolating your software so that one piece of software doesn't break another. This isn't a new concept and one could argue that really that's what kernel controlled processes do. Each process has its own memory space and, as far as the process is concerned, the memory space is the same as the computer's memory space. However the kernel is lying to the process and is really remapping the memory addresses the program is using into the real memory space. If you consider the speed of processors today and the ubiquity of systems capable of running more than one process at a time then, as a civilization, we are lying at a rate several orders of magnitude greater than any other point in human history. 

Any way, docker extends the process isolation model such that the isolation is stronger. Docker is a series of tools built on top of the linux kernel. The entire file system is now abstracted away, networking is virtualized, other processes are hidden and, in theory, it is impossible to break out of a container and damage other processes on the same machine. In practice everybody is very open about how it might be possible to break out of machine or, at the very least, gather information from the system running the container. Containers are a weaker form of isolation than virtual machines.

![http://imgur.com/ntGolVE.png](http://i.imgur.com/ntGolVE.png)

On the flip side processes are more performant than containers which are, in turn more performant than virtual machines. The reason is simple: with more isolation more things need to run in each context bogging the machine down. Choosing an isolation level is an exercise in deciding how much trust you have in the processes you run to no interference with other things. In the scenario where you've written all the services then you can have a very high level of trust in them and run them with minimal isolation in a process. If it is SAP then you probably want the highest level of isolation possible:  put the computer in a box and fire it to the moon. 

Another nice feature of docker is that the containers can be shipped as a whole. They tend not to be prohibitively large as you might see with a virtual machine. This vastly improves the ease of deploy. In a world of micro-services it is easy to bundle up your services and ship them off as images. You can even have the result of your build process be a docker image. 

The degree to which docker will change the world of software development and deployment remains an open one. While I feel like docker is a fairly disruptive technology the impact is still a couple of years out. I'd like to think that it is going to put a bunch of system administrators out of a job but in reality it is just going to change their job. Everybody needs a little shakeup now and then to keep them on their toes. 

Anyway back to docker on OSX:

If you read carefully to this point you might have noticed that I said that docker runs on top of the Linux kernel. Of course OSX doesn't have a linux kernel on which you can run docker. To solve this we actually run docker on top of a small virtual machine. To manage this we used to use a tool called boot2docker but this has, recently, been replace with docker-machine. 

I had an older install of docker on my machine but I thought I might like to work a bit with docker compose as I was running a number of services.  Docker compose allows for coordinating a number of containers to setup a whole environment. In order to keep the theme of isolating services it is desirable to run each service in its own container. So if you imagine a typical web application we would run teh web server in one container and the database in another one. These containers can be on the same machine.  

Thus I grabbed the installation package from the docker website then followed the installation instructions at [http://docs.docker.com/mac/step_one/](http://docs.docker.com/mac/step_one/). With docker installed I was able to let docker-machine create a new virtual machine in virtual box. 

![http://i.imgur.com/5uQjfq8.jpg](http://i.imgur.com/5uQjfq8.jpg)

All looks pretty nifty. I then kicked off the ubiqutious hello-world image

<pre>~/Projects/western-devs-website/_posts$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world

535020c3e8ad: Pull complete 
af340544ed62: Pull complete 
Digest: sha256:a68868bfe696c00866942e8f5ca39e3e31b79c1e50feaee4ce5e28df2f051d5c
Status: Downloaded newer image for hello-world:latest

Hello from Docker.
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker Hub account:
 https://hub.docker.com

For more examples and ideas, visit:
 https://docs.docker.com/userguide/
 </pre>

It is shocking how poorly implemented this image is, notice that at no point does it actually just print "Hello World". Don't worry, though, not everything in docker land is so poorly implemented. 

This hello world demo is kind of boring so let's see if we can find a more exciting one. I'd like to serve a web page from the container. To do this I'd like to use nginx. There is already an nginx container so I can create a new Dockerfile for it. A Dockerfile gives docker some instructions about how to build a container out of a number of images. The Dockerfile here contains 

<pre>
FROM nginx
COPY *.html /usr/share/nginx/html/
</pre>

The first line set the base image on which we want to base our container. The second line copies the local files with the .html extension to the web server directory on the nginx server container. To use this file we'll have to build a docker image

<pre>
/tmp/nginx$ docker build -t nginx_test .
Sending build context to Docker daemon 3.072 kB
Step 0 : FROM nginx
latest: Pulling from library/nginx
843e2bded498: Pull complete 
8c00acfb0175: Pull complete 
426ac73b867e: Pull complete 
d6c6bbd63f57: Pull complete 
4ac684e3f295: Pull complete 
91391bd3c4d3: Pull complete 
b4587525ed53: Pull complete 
0240288f5187: Pull complete 
28c109ec1572: Pull complete 
063d51552dac: Pull complete 
d8a70839d961: Pull complete 
ceab60537ad2: Pull complete 
Digest: sha256:9d0768452fe8f43c23292d24ec0fbd0ce06c98f776a084623d62ee12c4b7d58c
Status: Downloaded newer image for nginx:latest
 ---> ceab60537ad2
Step 1 : COPY *.html /usr/share/nginx/html/
 ---> ce25a968717f
Removing intermediate container c45b9eb73bc7
Successfully built ce25a968717f
</pre>

The docker build command starts by pulling down the already build nginx container. Then it copies our files over and reports a hash for the container which makes it easily identifiable. To run this container we need to do

<pre>
/tmp/nginx$ docker run --name simple_html -d -p 3001:80 -p 3002:443 nginx_test
</pre>

This instructs docker to run the container nginx_test and call it simple_html. The -d tells docker to run the container in the background and finally the -p give the ports to forward, in this case we would like our local machine's port 3001 to be mapped to the port inside the docker image 80 - the normal web server port. So now we should be able to connect to the web server. If we open up chrome and go to localhost:3001 we get 

![http://i.imgur.com/8Hdq9hN.jpg](http://i.imgur.com/8Hdq9hN.jpg)

Well that doesn't look right! The problem is that docker doesn’t realize that it is being run in a virtual machine so we need to forward the port from the vm to our local machine

  Docker container:80 -> vm host:3001 -> OSX:3001

This is easily done from the virtual machine manager 

![http://i.imgur.com/cGXHwRZ.jpg](http://i.imgur.com/cGXHwRZ.jpg)

Now we get 

![http://i.imgur.com/h8UJTSN.jpg](http://i.imgur.com/h8UJTSN.jpg)

This is the content of the html file I put into the container. Perfect! I'm now ready to start playing with more complex containers. 

**Tip**

One thing I have found is that running docker in virtual box at the same time as running parallels causes the whole system to hang. I suspect that running two different virtual machine tools is too much for something and a conflict results. I believe there is an effort underway to bring parallels support to docker-machine for the 0.5 release. Until then you can read [http://kb.parallels.com/en/123356](http://kb.parallels.com/en/123356) and look at the docker-machine fork at [https://github.com/Parallels/docker-machine](https://github.com/Parallels/docker-machine).
