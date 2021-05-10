---
title:  Setting Timezone from Powershell
authorId: simon_timms
date: 2021-05-10
originalUrl: https://blog.simontimms.com/2021/05/10/set-timezone
mode: public
---



This is pretty easy. 

```powershell
Set-Timezone -Id "US Eastern Standard Time"
```

You need to know the id of the timezone and you can figure that out using 

```powershell
Get-Timezones
```

```
Id                         : Dateline Standard Time
DisplayName                : (UTC-12:00) International Date Line West
StandardName               : Dateline Standard Time
DaylightName               : Dateline Daylight Time
BaseUtcOffset              : -12:00:00
SupportsDaylightSavingTime : False

Id                         : UTC-11
DisplayName                : (UTC-11:00) Coordinated Universal Time-11
StandardName               : UTC-11
DaylightName               : UTC-11
BaseUtcOffset              : -11:00:00
SupportsDaylightSavingTime : False
...
```

You can also see the current timezone by running 

```powershell
Get-Timezone
```

```
Id                         : Mountain Standard Time
DisplayName                : (UTC-07:00) Mountain Time (US & Canada)
StandardName               : Mountain Standard Time
DaylightName               : Mountain Daylight Time
BaseUtcOffset              : -07:00:00
SupportsDaylightSavingTime : True
```