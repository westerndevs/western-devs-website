---
layout: post
title: Bulk Load and Merge Pattern
authorId: simon_timms
date: 2019-10-12

---

The more years you spend programming the more you run into situations you've run into before. Situations you now know, instinctively, how to address. I suppose this is "experience" and is what I'm paid the medium dollars for. One such problem I've solved at least a dozen times over the years is updating a bunch of data in a database from an external source. This, as it turns out, can be a great source of poor performance if you don't know how to address it. Let's dig into my approach.

<!-- more -->

To start with let's give some examples of the problem 

* update a database with the result of a web service call
* load an Excel workbook or CSV file into the database
* synchronize an external data source with your own cache in a database

The approach that I commonly see people take is to get the records to load into the database and loop over them, checking them against existing records. It looks something like 

```csharp
public void Update(DbContext context, IEnumerable<ExternalData> toLoad)
{
    foreach(var record in toLoad){
        var dbRecord = context.Find(record.Id);
        if(dbRecord != null)
        {
            dbRecord.Field1 = record.Field1;
            ...
            context.Save(dbRecord);
        }
        else {
            context.Add(record);
        }
    }
}
```

This is a pretty logical approach. Any existing record is updated, any new record is inserted. Problem is that you're running 2 database operations for every record that comes in. Try to load 10k records and all of a sudden you're in for a world of hurt. It gets even scarier if you're running all this inside a transaction which might live a minute or two. Operations like this are likely to be subject to lock escalation up to table locks which is certainly not something you want.  

# Bulk Loading

Way back in my university days we had a database class which was so popular the professor taught 2 sessions back to back. This professor was famous for wearing brown sweaters no matter the time of year. Because we had two sessions every day I'd grab somebody from the previous class and ask what the class covered that day. 

On this day the professor was talking about bulk loading, it was the subject of some of his research. I asked a fellow in the previous class what they covered 

"Bulk loading and how much faster it is than regular inserts"

"Oh yeah? How much faster?"

"312 times, I think it was"

So down into the basement I trudged, into the windowless class room. The class started and the professor asked 

"How many times faster do you think bulk loading is?"

He sat back, waiting for the ridiculous answers, comfortable in the knowledge that he'd spend the last month writing paper on exactly this subject. 

"312 times, sir" I answered

He was flabbergasted that somebody would know this. He'd just spent the last month figuring out that exact number. Eventually I let him off the hook and told him where I'd found out his precise number but not until I span him some story about how Donald Kunth was my uncle.

Anyway the point of this story is that I'm a better person now and that bulk loading is way faster than doing individual inserts. When loading data into the database I like to load the data into a bulk loading table instead of directly into the destination table. That provides a staging area where changes can be made.

In C# the bulk loading API is a bit [comically dated](https://blogs.msdn.microsoft.com/nikhilsi/2008/06/11/bulk-insert-into-sql-from-c-app/) and relies on data tables. There are some nice wrappers for it including [dapper-plus](https://dapper-plus.net/bulk-insert). Using bulk copy speeds up loading substantially, perhaps not 312 times but I've certainly seen 50-100x. This reduces the chances that the transaction will run for a long time and having it run against a non-production table makes things even less likely to be problematic. 

With the data loaded we can now merge it into the live data, for this we can make use of merge.

# Merge Statement

I have a long list of features that SQL server is, frustratingly, missing. On that list is a simple upsert statement where you can tell the database what to do if there is a conflict. Both [Postgresql](http://www.postgresqltutorial.com/postgresql-upsert/) and [MySQL](https://www.techbeamers.com/mysql-upsert/) have a nice syntax for upsert. On SQL Server you have to wade through the complex `MERGE` statement. The [documentation](https://docs.microsoft.com/en-us/sql/t-sql/statements/merge-transact-sql?view=sql-server-ver15) for `MERGE` has on off the longest grammars for a statement I've ever seen; as you would expect for such a powerful a command.


A very simple example looks like this
```sql
MERGE HotelRooms AS target  
    USING (SELECT @roomNumber, @occupants from bulkLoadHotelRooms) AS source (roomNumber, occupants)  
    ON (target.roomNumber = source.roomNumber)  
    WHEN MATCHED THEN
        UPDATE SET Name = source.occupants  
    WHEN NOT MATCHED THEN  
        INSERT (roomNumber, occupants)  
        VALUES (source.roomNumber, source.occupants) 
```

This will insert records into the table `HotelRooms` from the bulk load table `BulkLoadHotelRooms` matching them on the room number (the `MATCHED` clause). If there is already a room number there then the occupants are updated (the `NOT MATCHED` clause). Not shown here there is also the ability to delete records which aren't in the target table. Also not shown are about 10 more clauses. The documentation is certainly worthwhile reading. 

# Wrapping Up

Bulk loading and merging is the best approach I've found so far to load data into a database. I've loaded millions of records on dozens of projects using this approach. If there is a better way that you've found, I'd love to hear about it. 