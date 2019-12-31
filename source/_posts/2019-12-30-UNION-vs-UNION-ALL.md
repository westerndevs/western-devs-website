layout: post
title: UNION vs. UNION ALL in SQL Server
authorId: simon_timms
date: 2019-12-30 9:00

---

I really dislike database queries which are slow for no apparent reason. I ran into one of those today. It queries over a few thousands of well indexed rows and returned a handful, perhaps 3, records. Time to do this? 33 seconds. Well that's no good for anybody. Digging into the query I found that it actually used a `UNION` to join 3 sets of similar data together. I go by the rule of thumb that SQL operations which treat data as sets and do things with that in mind are efficient. I'm not sure where I read that but it has stuck with me over the years.  What it suggests is that you should avoid doing things like looping over rows or calling functions on masses of data. 

As it turns out there are actually two different `UNION` operators in SQL Server: `UNION` and `UNION ALL`. They differ in how they handle duplicate entries. `UNION` will check each entry to ensure that it exists in the output only one time. 

<!--more-->

So if you had results like 

```sql
select * from a

ID     Name
 1     Bob
 2     Jane

select * from b

ID     Name
 3     Sally
 2     Jane

```

The result of running

```sql
select * from a
union 
select * from b

ID     Name
 1     Bob
 3     Sally
 2     Jane

```

Here the duplicate record 2 is only returned once. On the other hand `UNION ALL` will assume that the result sets are already unique and return whatever it is given

```sql
select * from a
union all
select * from b

ID     Name
 1     Bob
 2     Jane
 3     Sally
 2     Jane

```

`UNION ALL` is, as a result of not doing this duplicate check, far faster than `UNION`. On the data sets I tried the savings were between 40% and 95%. It isn't always the right answer but is another tool on your toolbelt. 