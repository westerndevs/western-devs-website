---
title:  Sequences
authorId: simon_timms
date: 2021-06-03
originalurl: https://blog.simontimms.com/2021/06/03/sequence
mode: public
---



Sequences are a handy feature in SQL server which provide an increasing, unique number. You wouldn't typically use them directly but might use them under the covers in an `identity`. However from time to time they are useful when you need numbers but your primary key is a `uniqueidentifier` or you need two different ways of numbering records. I've been using them to associate records in a table into groups. 

```
create SEQUENCE Seq_PermitNumber 
    start with 1 
    increment by 1
```

You can then use them like this

```
update tblManualPayment 
   set PermitNumber = next value for Seq_PermitNumber 
 where PermitNumber is null
```

This will give each record a unique permit number. 