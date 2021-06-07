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