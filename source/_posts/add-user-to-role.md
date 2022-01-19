---
title:  Add user to role in sql server
authorId: simon_timms
date: 2021-06-07
originalurl: https://blog.simontimms.com/2021/06/07/add-user-to-role
mode: public
---



This can be done with 

```
sp_addrolemember @rolename = 'role', @membername = 'security_account'
```

example

```
sp_addrolemember @rolename = 'db_owner', @membername = 'evil_hacker_account'
```

another example

```
sp_addrolemember @rolename = 'db_datareader', @membername = 'datafactory'
```

and another 

```
sp_addrolemember @rolename = 'db_datawriter', @membername = 'asca_webapp'
```

Built in database roles are 

**db_owner** Members of the db_owner fixed database role can perform all configuration and maintenance activities on the database, and can also drop the database in SQL Server. (In SQL Database and Azure Synapse, some maintenance activities require server-level permissions and cannot be performed by db_owners.)
**db_securityadmin** Members of the db_securityadmin fixed database role can modify role membership for custom roles only and manage permissions. Members of this role can potentially elevate their privileges and their actions should be monitored.
**db_accessadmin** Members of the db_accessadmin fixed database role can add or remove access to the database for Windows logins, Windows groups, and SQL Server logins.
**db_backupoperator** Members of the db_backupoperator fixed database role can back up the database.
**db_ddladmin** Members of the db_ddladmin fixed database role can run any Data Definition Language (DDL) command in a database.
**db_datawriter** Members of the db_datawriter fixed database role can add, delete, or change data in all user tables.
**db_datareader** Members of the db_datareader fixed database role can read all data from all user tables and views. User objects can exist in any schema except sys and INFORMATION_SCHEMA.

**db_denydatawriter** Members of the db_denydatawriter fixed database role cannot add, modify, or delete any data in the user tables within a database.

**db_denydatareader** Members of the db_denydatareader fixed database role cannot read any data from the user tables and views within a database.