---
layout: post
title:  "Updating Sub-Collections With SQL Server's Merge"
date: 2015-12-15T21:52:50-07:00
comments: true
excerpt: When you get to be as old as me then you start to see certain problems reappearing over and over again. I think this might be called "experience" but it could also be called "not getting new experiences".
authorId: simon_timms
originalurl: http://blog.simontimms.com/2015/12/16/updating-sub-collections-with-sql-servers-merge/
---

When you get to be as old as me then you start to see certain problems reappearing over and over again. I think this might be called "experience" but it could also be called "not getting new experiences". It might be that instead of 10 years experience I have the same year of experience 10 times. Of course this is only true if you don't experiment and find new ways of doing things. Even if you're doing the same job year in and year out it is how you approach the work that determines how you will grow as a developer.

<!--more--> 

One of those problems I have encountered over the years is the problem of updating a collection of records related to one record. I'm sure you've encountered the same thing where you present the user with a table and let them edit, delete and add records.

![A collection of rows](http://i.imgur.com/QCYisPG.png)

Now how do you get that data back to the server? You could send each row back individually using some Ajax magic. This is kind of a pain, though, you have to keep track of a lot of requests and you're making a bunch of requests. You also need to track, behind the scenes, which rows were added and which were removed so you can send specific commands for that. It is preferable to send the whole collection at once in a single request. Now you've shifted the burden to the server. In the past I've handled this by pulling the existing collection from the database and doing painful comparisons to figure out what has changed. 

There is a very useful SQL command called UPSERT which you'll find in databases such as Postgres(assuming you're on the cutting edge and you're using 9.5). Upsert is basically a command which looks at the existing table data when you modify a record. If the record doesn't exist it will be created and if it is already there the contents will be updated. This solves 2/3rds of our cases with only delete missing. Unfortunately, SQL Server doesn't support the UPSERT command - however it does support MERGE. 

I've always avoided MERGE because I thought it to be very complicated but in the interests of continually growing I figured it was about time that I bit the bullet and just learned how it works. I use Dapper a fair bit for talking to the database, it is just enough ORM to handle the dumb stuff while still letting me write my own SQL. It is virtually guaranteed that I write worse SQL than a full ORM but that's a cognitive dissonance I'm prepared to let ride. By writing my own SQL I have direct access to tools like merge which might, otherwise, be missed by a beefy ORM. 

The first thing to know about MERGE is that it needs to run against two tables to compare their contents. Let's extend the example we have above of what appears to be a magic wand shop... that's weird and totally not related to having just watched the trailer for [Fantastic Beasts and Where to Find Them](https://www.youtube.com/watch?v=Wj1devH5JP4). Anyway our order item table looks like 

{% codeblock lang:sql %}
create table orderItems(id uniqueidentifier,
              orderId uniqueidentifier,
              colorId uniqueidentifier,
              quantity int)
{% endcodeblock %}

So the first task is to create a temporary table to hold our records. By prefacing a table name with a `#` in SQL server we get a temporary table which is unique to our session. So other running transactions won't see the table - exactly what we want.

{% codeblock lang:sql %}
using(var connection = GetConnection())
{
   connection.Execute(@"create table #orderItems(id uniqueidentifier,
               orderId uniqueidentifier,
               colorId uniqueidentifier,
               quantity int)");
}
{% endcodeblock %}
Now we'll take the items collection we have received from the web client (in my case it was via an MVC controller but I'll leave the specifics up to you) and insert each record into the new table. Remember to do this using the same session as you used to create the table. 

{% codeblock lang:csharp %}
foreach(var item in orderItems)
{
    connection.Execute(@"insert into #orderItems(id, 
			orderId, 
			colorId, 
			quantity) 
		values(@id, 
			@orderId, 
			@colorId, 
			@quantity)", item);
}
{% endcodeblock %}

Now the fun part: writing the merge. 

{% codeblock lang:sql %}
merge orderItems as target
      using #orderItems as source
      on target.Id = source.Id 
      when matched then
           update set target.colorId = source.colorId, 
                  target.quantity = soruce.quantity
      when not matched by target then 
	  insert (id, 
      		  orderId, 
              colorId, 
              quantity) 
     values (source.id, 
     		 source.orderId, 
             source.colorId, 
             source.quantity)
     when not matched by source 
      and orderId = @orderId then delete;
{% endcodeblock %}

What's this doing? Let's break it down. First we set a target table this is where the records will be inserted, deleted and updated. Next we set the source the place from which the records will come. In our case the temporary table. Both `source` and `destination` are aliases so really they can be whatever you want like `input` and `output` or `Expecto` and `Patronum`.

{% codeblock lang:sql %}
merge orderItems as target
      using #orderItems as source
{% endcodeblock %}

This line instructs on how to match. Both our tables have primary ids in a single column so we'll use that.

{% codeblock lang:sql %}
on target.Id = source.Id 
{% endcodeblock %}

If a record is matched the we'll update the two important target fields with the values from the source.

{% codeblock lang:sql %}
when matched then
           update set target.colorId = source.colorId, 
                  target.quantity = soruce.quantity
{% endcodeblock %}

Next we give instructions as to what should happen if a record is missing in the target. Here we insert a record based on the temporary table.

{% codeblock lang:sql %}
when not matched by target then 
	  insert (id, 
      		  orderId, 
              colorId, 
              quantity) 
     values (source.id, 
     		 source.orderId, 
             source.colorId, 
             source.quantity)
{% endcodeblock %}

Finally we give the instruction for what to do if the record is in the target but not in the source - we delete it. 

{% codeblock lang:sql %}
when not matched by source 
     and orderId = @orderId then delete;
{% endcodeblock %}

In another world we might do a soft delete and simply update a field.

That's pretty much all there is to it. MERGE has a ton of options to do more powerful operations. There is a bunch of super poorly written documentation on this on [MSDN](https://msdn.microsoft.com/en-us/library/bb510625.aspx?f=255&MSPPError=-2147217396) if you're looking to learn a lot more.

