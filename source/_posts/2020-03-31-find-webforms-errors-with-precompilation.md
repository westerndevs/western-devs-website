---
layout: post
title: Solve WebForms Errors with PreCompilation
authorId: simon_timms
date: 2020-03-31 20:00
originalUrl: 'https://blog.simontimms.com/2020/03/31/2020-03-31-find-webforms-errors-with-precompilation/'
---

I have a webforms application that I help maintain. Today I made some change and managed to break one of the pages on the site. The error was unbelievably unhelpful.

![Wut? 500 error with no useful details](https://blog.simontimms.com/images/precompilewebforms/500.png)

In older versions of ASP.NET it is nearly impossible to diagnose these sorts of errors. Was it something with the web.config? Did I mess up the dependency injection? I messed about a bit and found that if I deleted everything out of the `.aspx` file things worked. So it was the view. But what? 

<!-- more -->

I don't know where the logs go for these sorts of errors but I couldn't find them. But knowing that the error was in the ASPX file I figured I could get the errors by compiling the files. You can actually precompile the ASPX files pretty easily in your post build step. It does take some time so I don't typically have it enabled for development but this is the command

```
%windir%\Microsoft.NET\Framework64\v4.0.30319\aspnet_compiler.exe -v / -p "$(SolutionDir)$(ProjectName)"
```

Sure enough running that build gave me the error message I was looking for: 

```
error ASPPARSE: Literal content ('<!--') is not allowed within a 'Telerik.Web.UI.GridColumnCollection'.
```

This is the second time in a week XML comments caught me. But the story here is that if you're running into unexpected 500 errors on a webform page try compiling the page using `aspnet_compiler`