---
title:  Reauthenticate with Nuget
authorId: simon_timms
date: 2021-08-31
originalurl: https://blog.simontimms.com/2021/08/31/reauth-nuget
mode: public
---



If you have a private nuget feed authenticated with a password chances are your password will eventually expire or change. For some reason Visual Studio and perhaps nuget under the covers aggressively caches that password and doesn't prompt you when the password doesn't work anymore. To change the password the easiest approach I've found is to use the nuget.exe command line tool and run 

```
c:\temp\nuget.exe sources update -Name "Teamcity" -Source "https://private.nuget.feed.com/httpAuth/app/nuget/feed/_Root/SomeThing/v2" -UserName "simon.timms" -Password "Thisisactuallymypassword,no,really"
C:\temp\nuget.exe list -Source teamcity
```