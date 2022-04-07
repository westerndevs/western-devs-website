---
title:  Which SQL Hosting Option is Right for Me?
authorId: simon_timms
date: 2022-04-07
originalurl: https://blog.simontimms.com/2022/04/07/which_sql_server_edition
mode: public
---



There are a bunch of different ways to host SQL Server workloads on Azure. Answering some questions about how you use SQL server can help guide us to picking the right option for you.

The 3 options for hosting we're considering are 

1. SQL Azure - https://azure.microsoft.com/en-us/products/azure-sql/database/#overview
2. Azure SQL Managed Instance - https://azure.microsoft.com/en-us/products/azure-sql/managed-instance/
3. SQL Server on VM - https://azure.microsoft.com/en-us/services/virtual-machines/sql-server/#overview

I've listed these in my order of preference. I'd rather push people to a more managed solution than a less managed one. There is a huge shortage of SQL server skills out there so if you can take a more managed approach then you're less likely to run into problems that require you finding an SQL expert. I frequently say to companies that they're not in the business of managing SQL server but in the business of building whatever widgets they build. Unless there is a real need don't waste company resources building custom solutions when you can buy a 90% solution off the shelf. 

When I talk with companies about migrating their existing workloads to the cloud from on premise SQL servers I find myself asking these questions:

1. Does your solution use cross database joins?
2. Does your solution make use of the SQL Agent to run jobs?
3. Does your solution use FILESTREAM to access files on disk? 
4. Does your solution require fine tuning of availability groups?
5. Does your solution require SQL logins from `CERTIFICATE`, `ASYMMETRIC KEY` or `SID`?
6. Do you need to make use of a compatibility level below 100?
7. Do you need to make use of database mirroring?
8. Does your solution need to start and stop job scheduling?
9. Are you making use of SQL Server Reporting Services (SSRS)?
10. Are you using xp_cmdshell anywhere in your application (https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/xp-cmdshell-transact-sql?view=sql-server-ver15)

If the answer to any of the first 3 questions is `yes` then they can't easily use SQL Azure* and should set the baseline to a managed instance. If the answer to any of the rest of the questions is `yes` then they should set the baseline to a VM running a full on version of SQL Server. Only if the answer to all these questions is `no` is SQL Azure the best solution. 

* Cross database joins and SQL Agent can be replaced by Elastic Query and Elastic Jobs but neither one is an easy drop in replacement so I typically don't bother directing people to them for time constrained migrations. 