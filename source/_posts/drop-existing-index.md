---
title:  Create or Update Index
authorId: simon_timms
date: 2021-05-08
originalurl: https://blog.simontimms.com/2021/05/08/drop-existing-index
mode: public
---



Of course the SQL server syntax for this doesn't quite jive with what I want but you can use the clause ` WITH (DROP_EXISTING = ON)` to have SQL server handle updating an existing index keeping the old index live until the new version is ready. You use it like 

```sql
CREATE NONCLUSTERED INDEX idxMonthlyParkers_vendor_expiry_issue
ON [dbo].[tblParkers] ([VendorId],[LotTimezoneExpiryDate],[LotTimezoneIssueDate])
INCLUDE ([HangTagCode],[FirstName],[LastName])
 WITH (DROP_EXISTING = ON)
```

However that will throw an error if the index doesn't exist (of course) so you need to wrap it with an `if`

```sql
if exists (SELECT * 
FROM sys.indexes 
WHERE name='idxMonthlyParkers_vendor_expiry_issue' AND object_id = OBJECT_ID('dbo.tblMonthlyParker'))
begin
    CREATE NONCLUSTERED INDEX idxMonthlyParkers_vendor_expiry_issue
    ON [dbo].[tblParkers] ([VendorId],[LotTimezoneExpiryDate],[LotTimezoneIssueDate])
    INCLUDE ([HangTagCode],[FirstName],[LastName])
    WITH (DROP_EXISTING = ON)
end
else 
begin
    CREATE NONCLUSTERED INDEX idxMonthlyParkers_vendor_expiry_issue
    ON [dbo].[tblParkers] ([VendorId],[LotTimezoneExpiryDate],[LotTimezoneIssueDate])
    INCLUDE ([HangTagCode],[FirstName],[LastName])
end
```

