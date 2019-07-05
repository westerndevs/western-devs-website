---
layout: post
title: Debug PHP Inside A Container with VSCode
authorId: simon_timms
date: 2019-07-05 19:00

---

Sometimes good things happen to bad people and sometimes bad things happen to good people. I'll let you decide which one me developing a PHP application is. Maybe it is a bit of a mixture. This particular PHP app was a bit long in the tooth (what PHP app isn't) and ran on full VMs. My first operation was was to get it running inside a docker container because I couldn't be sure that my Windows development environment would be representative of production, then I wanted to be able to debug it. This is the story of how to do that.

<!-- more -->

Fortunately, I had some instructions on how to set up the VMs based on CentOS. Ah the good old days when installation instructions were written in word documents. The setup was a pretty standard LAMP stack and translated okay to a docker container. 

![LAMP stack - Linux, Apache, MySQL and PHP/Perl/Python](https://blog.simontimms.com/images/phpincontainer/lamp_stack.jpg)

Running the application was one thing, but I decided that what I really needed was the ability to attach a debugger to my PHP process. The PHP process inside the container. We are living in an age were VS Code is pretty amazing and it didn't fail to fulfill that promise this time. A recently announced feature in VS Code is the ability to split the front and back end of the editor. The persistence and language engines can run on a different machine from the user interface. In effect you're attaching to a remote sharing session except that the other end is inside the container. 

Mind blown.

To set it up for PHP took a little bit it work. The first thing I did was install the xdebug extension for PHP. This I did by adding some lines to my Dockerfile.

```dockerfile
##### debugging environment #####
# install pecl
RUN yum -y install php-pear git
# specific version of xdebug for the ancient php we're running
RUN pecl install xdebug-2.2.4
# add module to loaded modules
RUN echo 'zend_extension=/usr/lib64/php/modules/xdebug.so' >> /etc/php.d/xdebug.ini
# set up the environment
ENV XDEBUG_CONFIG "remote_host=localhost remote_port=9000 remote_enable=1"
```

This installs xdebug and tells it to connect to the development environment found on port 9000 which is going to be the VS Code back-end running in the container. You can connect to any host using this so if you needed to debug on some remote machine you could have xdebug connect to your local machine no problem. 

Next I set up a `launch.json` in VS Code's `.vscode` directory which allowed VS Code to start debugging by listening to port 9000.

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for XDebug",
            "type": "php",
            "request": "launch",
            "port": 9000
        }
    ]
}
```

Finally I created a `.devcontainer/devcontainer.json` file which gives the remote extensions in VS Code knowledge of how to start up a container for development.

```json
{
    "name": "Portal",
    "image": "portal",
    "appPort": ["8080:80"],
    "extensions": [
        "felixfbecker.php-debug"
    ],
    "postCreateCommand": "git config --global core.autocrlf true"
}
```

The container is to forward port 80 to my localhost 8080 so that I can use the web browser to connect to the site. Inside the container I want the debugger extension installed so I list it under extensions. Any additional extensions like `bmewburn.vscode-intelephense-client` could also be listed here. Finally because I'm running on Windows and copying the source code over to a Linux image I run a command to change the line endings in git. 

The last step is to install the Remote Development extensions which is what allows VS Code to be split between machines. Once it is installed you'll be prompted to reopen the folder inside a container. 

![The prompt when you open VS Code](https://blog.simontimms.com/images/phpincontainer/launch_in_container.png)

If you click reopen in container VS code restarts with the back end running in the container. You can tell by looking at the bottom left corner of the editor. 

![Showing you're in a container](https://blog.simontimms.com/images/phpincontainer/in_container.png)


With that all set up I was able to add break points and actually intercept calls to the PHP code. 

![Hitting a breakpoint](https://blog.simontimms.com/images/phpincontainer/at_breakpoint.png)

Super-cool!