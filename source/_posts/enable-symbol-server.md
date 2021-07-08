---
title:  Enable TeamCity Symbol Server
authorId: simon_timms
date: 2021-07-08
originalurl: https://blog.simontimms.com/2021/07/08/enable-symbol-server
mode: public
---



First off a symbol server is a server which stores the symbols from a built binary so you don't have to ship out PDB files with your compiled code to be able to debug it. You can hook up visual studio to search a symbol server when you're debugging so that you can drop into code for something like a shared nuget package. Teamcity, as it turns out, has a plugin to support being a symbol server. Here is how you get started with it:

1. Install the symbol server plugin by going to Administration > plugins > Browse plugins repository and search for `symbol`
2. On your build agents install the windows debugging tools which are shipped as part of the Windows SDK. For windows 10 you can grab it here: https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk/ During the install you'll be prompted for which components you want to install and you can just turn off everything but the debugging tools.
3. Remember to restart your build agents so they can register the debugging tools as being installed. You can check by going to the build agent in teamcity. Click on parameters
![](/images/2021-07-08-enable-symbol-server.md/2021-07-08-16-29-31.png))
In there, at the bottom, you should find an entry for the debugger
![](/images/2021-07-08-enable-symbol-server.md/2021-07-08-16-29-59.png))
4. In the projects you want symbols for enable the symbol server feature
![](/images/2021-07-08-enable-symbol-server.md/2021-07-08-16-31-20.png))
5. In the build artifacts you need to ensure that both the PDB and the associated EXE or DLL are selected as artifacts. 
![](/images/2021-07-08-enable-symbol-server.md/2021-07-08-16-32-51.png))

That's pretty much it. In your build now you should see a few log messages to let you know that the symbol server indexing is working
![](/images/2021-07-08-enable-symbol-server.md/2021-07-08-16-45-53.png))

Now you can hook up Visual Studio to use this by going into settings and searching for `symbols` then paste the URL of the teamcity server with `/app/symbols` at the end of it into the box
![](/images/2021-07-08-enable-symbol-server.md/2021-07-08-16-49-54.png))

Now when you're debugging in visual studio you'll have access to the symbols. 