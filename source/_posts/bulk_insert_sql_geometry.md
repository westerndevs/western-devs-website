---
title:  Bulk Insert SQL Geometry on .NET Core 
# Gotchas
authorId: simon_timms
date: 2022-11-17
originalurl: https://blog.simontimms.com/2022/11/17/bulk_insert_sql_geometry
mode: public
---



I have been updating an application from full framework to .NET 6 this week. One of the things this app does is bulk load data into SQL Server. Normally this works just fine but some of the data is geography data which requires a special package to be installed: `Microsoft.SqlServer.Types`. This package is owned by the SQL server team so, as you'd expect, it is ridiculously behind the times. Fortunately, they are working on updating it and it is now available for Netstandard 2.1 in a preview mode. 

The steps I needed to take to update the app were: 

1. Install the preview package for `Microsoft.SqlServer.Types`
2. Update the SQL client package from System.Data.SqlClient to Microsoft.Data.SqlClient

After that the tests we had for inserting polygons worked just great. This has been a bit of a challenge over the years but I'm delighted that we're almost there. We just need a non-preview version of the types package and we should be good to go. 

## Gotchas

When I'd only done step 1 I ran into errors like 

```
System.InvalidOperationException : The given value of type SqlGeometry from the data source cannot be converted to type udt of the specified target column.
---- System.ArgumentException : Specified type is not registered on the target server. Microsoft.SqlServer.Types.SqlGeometry, Microsoft.SqlServer.Types, Version=16.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91.
```

I went down a rabbit hole on that one before spotting a post from MVP Erik Jensen https://github.com/ErikEJ/EntityFramework6PowerTools/issues/103 which sent me in the right direction. 