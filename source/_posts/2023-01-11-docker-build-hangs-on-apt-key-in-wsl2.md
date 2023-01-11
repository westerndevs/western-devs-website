---
title: Docker Build Hangs When Adding Key with apt-key in WSL2
date: 2023-01-11T21:43:58.005Z
categories:
  - coding
  - problem-solution
tags:
  - docker
  - wsl2
  - apt-key
  - debian
  - linux
  - devcontainer
image-alt: A light blue cartoon style whale, meant to resemble the Docker logo,
  with a yellow-orange beak, like the Linux penguin, holding a key in it's
  mouth. Drawn with very small squares.
image-type: image/png
image-credit:
  derived-from: https://labs.openai.com/s/z8Gdu46DdNOGjAKCTXiY1mmW
originalurl: https://www.davidwesst.com/blog/docker-build-hangs-on-apt-key-in-wsl2
authorId: david_wesst
excerpt: The solution to the problem where an apt-key command seems to run
  forever in your docker build.
---

[1]: https://www.mono-project.com/download/stable/#download-lin-debian
[2]: https://github.com/davidwesst/inky/tree/8a5809f0b5f0a480b37b759443479fa13b9cf18c
[3]: https://github.com/davidwesst/inky/commit/52b9d1a2e577061ae1da735e05cf466712bb9279
[4]: https://unix.stackexchange.com/a/128704 
[5]: https://manpages.debian.org/testing/apt/apt-key.8.en.html
[6]: https://containers.dev/

## Problem 

When trying to add a key using `apt-key` on a Debian 11 docker image, the step seems to run infinitely.  

The screenshot below highlights this problem when adding a key that is necessary to validate the mono-complete package.

![A terminal window showing the steps of a docker build command along with their run times. The command that is currently being run is an apt-key command that is still running after 8078.8 seconds](/images/2023-01-11-docker-build-hangs-on-apt-key-in-wsl2/console-screenshot.png)

### Details 

I setup a [DevContainer][6] to build Inky, a interactive fiction editor I like for game projects, without having to install all the build dependencies on my local machine. The Docker container build worked on my Linux machine, but would hang on my Windows 11 box, using Docker Desktop with WSL2. More specifically, it would run forever on the `apt-key` command, as specified by the [mono install instructions][1]. 

If you need an example, take a look at [my Inky repository fork at that specific point][2].

## Solution 
 
The issue was that the command specifically references port 80 in the URL to the keyserver. In the end, I changed: 
 
`sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF` 
 
to  
 
`sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF`
 
You can see the specifics in the [next commit in my example repository][3] in the following commit here. 
 
### Reference 
 
I was put on the right track with a Stack Overflow post trying to solve a similar issue with `apt-key`. Scrolling through the answers, I found this one: [LINK][4]
 
### `apt-key` Deprecation Notice 
 
If you look at the [Debian documentation for `apt-key`][5] or try running the command yourself, you might notice the deprecation warning. Underneath the hood, it runs the appropriate command in Debian 11, but will be gone after Debian 11 and Ubuntu 22.04. 
 
Just something to note for those looking over this solution in the future. 
 
## Conclusion / TL;DR; 
 
I needed to remove the port number from the keyserver URL used in my `apt-key` command. 
 
Thanks for playing.

~ DW