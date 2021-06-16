---
title:  Quick Noda Time Conversions
# Convert a DateTime and TzDB Timezone to UTC
# Convert from a UTC to a zoned DateTime
authorId: simon_timms
date: 2021-06-16
originalurl: https://blog.simontimms.com/2021/06/16/noda-time
mode: public
---



Noda time makes working with timezones, well not a snap but better than dental surgery. 

## Convert a DateTime and TzDB Timezone to UTC

A TzDB timezone is one that looks like `America/Edmonton` or, one might presume `Mars/OlympusMons`

```
DateTimeZone timezone = DateTimeZoneProviders.Tzdb.GetZoneOrNull(timezoneId);
ZoneLocalMappingResolver customResolver = Resolvers.CreateMappingResolver(Resolvers.ReturnLater, Resolvers.ReturnStartOfIntervalAfter);
var localDateTime = LocalDateTime.FromDateTime(dateTime);
var zonedDateTime = timezone.ResolveLocal(localDateTime, customResolver);
return zonedDateTime.ToDateTimeUtc();
```

## Convert from a UTC to a zoned DateTime

```
 var local = new LocalDateTime(dateTime.Year, dateTime.Month, dateTime.Day, dateTime.Hour, dateTime.Minute, dateTime.Second);
var tz = DateTimeZoneProviders.Tzdb[timeZoneID];
return local.InZoneLeniently(tz);
```

But be careful with this one because it might produce weird results around time change periods. If you want to avoid ambiguity or at least throw an exception for it consider `InZoneStrictly`