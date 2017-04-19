---
layout: post
title: Using azure-cli in windows bash
tags:
  - azure
  - windows bash
categories:
  - messaging   
authorId: simon_timms
date: 2017-04-19 01:36:36

---

The latest versions of Windows support running linux executables. The technical trickery to get that done boggle my mind. I wanted to get the Azure command line tools working inside of the bash. The tools are written in python so we need to get that installed.

<!-- more -->

```
   sudo apt-get install python-pip python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev
```
This also installs some build tools which we'll need to install the actual azure-cli and pip which is kind of nuget for python. Now we just need to install the tools

```
   pip install --user azure-cli
```

This will install the tools to `~/.local/bin`. You might need to add that to your path or at least reload the profile by running `. ~/.profile`. Now you can login with 

```
az login
```

This will give you a code to enter in a browser which will complete you login and Bob's your uncle. Because python is portable this could all be done on Windows as well but I'm still more comfortable scripting against bash than powershell.  You can read more about az and all the sub-commands like `az acr` at https://docs.microsoft.com/en-us/cli/azure/overview. I'll probably also post some more content on it soon. 