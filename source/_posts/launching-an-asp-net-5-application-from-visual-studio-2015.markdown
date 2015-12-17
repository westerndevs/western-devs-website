---
layout: post
title:  "Launching an ASP.NET 5 Application From Visual Studio 2015"
date: 2015-07-31T14:21:46+02:00
categories:
comments: true
authorId: james_chambers
originalurl: http://jameschambers.com/2015/07/launching-an-asp-net-5-application-from-visual-studio-2015/
alias: /launching-an-asp-net-5-application-from-visual-studio-2015/
---

If you are trying to use any DNX (DotNet Execution) runtime other than dnx451 (i.e. dnx452, dnx46) you will run into the following error when running the application from Visual Studio 2015, when used with the initial release of the Beta 6 tooling:

> **The current runtime target framework is not compatible with 'YourWebApplication'.**
> 
> Current runtime Target Framework: 'DNX,Version=v4.5.1 (dnx451)'  
> Type: CLR  
> Architecture: x64  
> Version: 1.0.0-beta6-12256

If you're instead running with a debugger attached, you won't hit a breakpoint, you'll only get a 500. It doesn't matter what framework runtimes you have installed on your machine. It doesn't matter what your global.json says or what dependencies or frameworks you take or specify in project.json.

This is because the default runtime for launching IIS Express from Visual Studio is indeed dnx451. You can get around this in one of two ways:

1. Launch the website from the command line in your project directory using the command "dnx . web". Web is a command that is exposed in your project.json and shares the needed info (config) to launch a project-specific instance of IIS.
2. In your project properties (right-click, properties from Solution Explorer), add the following environment variable in the Debug tab:  
&nbsp;&nbsp;&nbsp;&nbsp; DNX_IIS_RUNTIME_FRAMEWORK = dnx46

![image][1]

A huge thanks goes out to [Andrew Nurse][2] for providing a resolution on [this matter][3] and responding to [my issue][4] on GitHub.

[1]: http://jameschambers.com/wp-content/uploads/2015/07/image25.png "image"
[2]: https://twitter.com/anurse
[3]: http://stackoverflow.com/questions/31671851/vs-2015-setting-right-target-framework-for-asp-net-5-web-project/31687529#31687529
[4]: https://github.com/aspnet/dnx/issues/2367
  