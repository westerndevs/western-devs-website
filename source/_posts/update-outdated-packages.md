---
title:  Update outdated Nuget packages
authorId: simon_timms
date: 2024-09-15
originalurl: https://blog.simontimms.com/2024/09/15/update-outdated-packages
mode: public
---



If you're using Visual Studio Code to develop C# applications, you might need to update outdated Nuget packages. You can do that without having to do each one individually on the command line using [dotnet outdated](https://github.com/dotnet-outdated/dotnet-outdated)

Install it with 

```bash
dotnet tool install --global dotnet-outdated
```

Then you can run it in the root of your project to list the packages which will be updated with 

```bash
dotnet outdated
```

Then, if you're happy, run it again with 

```bash
dotnet outdated -u
```

 to actually get everything updated.