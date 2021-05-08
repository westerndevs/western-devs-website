---
title:  Query BigTable Events
authorId: simon_timms
date: 2021-05-08
mode: public
---



Firebase can feed its data to bigtable and then you can run queries there. The syntax is SQL like but not quite because they have internal record types. So for the data that is fed across from firebase you get a structure that looks like 

![](/images/2021-03-05-query-collections-in-big-table.md/2021-03-05-10-39-05.png)

You can see that event_params and user_properties are these kind of collection things. The easiest way to deal with them is to flatten the structure and internally join the table against itself

```sql
SELECT r.event_name, p.key, p.value FROM `pocketgeek-auto.analytics_258213689.events_intraday_20210305` r cross join unnest(r.event_params) as p where key = 'DealerName'
```

This gets you a dataset like 

![](/images/2021-03-05-query-collections-in-big-table.md/2021-03-05-10-39-05.png)

```SQL
SELECT r.event_name, p.key, p.value FROM `pocketgeek-auto.analytics_258213689.events_intraday_20210305` r cross join unnest(r.event_params) as p where key = 'DealerName' and p.value.string_value <> 'none'
```
is probably even better with the filter