---
title:  Filtering Datatables
authorId: simon_timms
date: 2021-09-17
originalurl: https://blog.simontimms.com/2021/09/17/datatable-filtering
mode: public
---



Years back there was this crazy way of dealing with data in .NET called a DataSet. DataSets contained DataTables which contained a combination of DataRows and DataColumns. It was all loosely typed and keyed with strings. Basically a database inside of your process. Even when they were cool I felt uncomfortable using them. Because I sometimes maintain legacy code I run into these monstrosities. 

Today's problem was that I needed to filter the contents of a table before bulk loading it. You can actually do simple filtering using a quasi-SQL like

```
   var dataRows = existingDataTable.Select("UserName = 'simon'")
```

This gives you back a collection of DataRows which I guess you could inset back into the table after clearing it of rows. To make this useful there is an extension method called `CopyToDataTable` in `System.Data.DataExtension` (be sure to include the dll for this). Using that you can get back a full data table

```
var dataTable = existingDataTable.Select("UserName = 'simon'").CopyToDataTable();
```

In that same package, though, is a much better tool for filtering: converting the table to an IEnumerable. You still need to use some magic strings but that's somewhat unavoidable in data tables. 

```
var dt = existingDataTable.AsEnumerable()
                    .Where(r => r.Field<String>("UserName") == "Simon").CopyToDataTable();
```

You can also do more advanced things like checking to see if something is a GUID

```
var dt = existingDataTable.AsEnumerable()
                    .Where(r => Guid.TryParse(r.Field<String>("Id"), out var _)).CopyToDataTable();
```

