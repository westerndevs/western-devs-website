---
title:  SQL Mail
authorId: simon_timms
date: 2021-08-31
originalurl: https://blog.simontimms.com/2021/08/31/enable-database-mail
mode: public
---



Did you know you can hook up your SQL server (or Managed SQL on Azure) to an SMTP server and use it to send email. Terrible idea? Yes, probably. I really encourage people not to build business logic that might require creating an email into stored procs.  Required for legacy code? Yes, certainly. 

You first need to tell SQL server how to talk to the mail server. This is done using the `sysmail_add_Account_sp`

```
EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'Database Mail Account',
    @description = 'SQL Server Notification Service',
    @email_address = 'SQLServer@somedomain.com',
    @replyto_address = 'SQLServer@somedomain.com',
    @display_name = 'Database Mail Profile',
    @mailserver_name = 'smtp.office365.com',
    @port = 587,
	@username = 'SQLServer@somedomain.com',
	@password = 'totallynotourpassword',
	@enable_ssl = 1;
```

With that in place you can set up a mail profile to use it

```
SELECT @sequence_number = COALESCE(MAX(profile_id),1) FROM msdb.dbo.sysmail_profile;

-- Create a mail profile
EXECUTE msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'Database Mail Profile',
    @description = 'Sends email from the db';
                              
-- Add the account to the profile
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'Database Mail Profile',
    @account_name = 'Database Mail Account',
    @sequence_number = @sequence_number;
                              
-- Grant access to the profile to the DBMailUsers role
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'Database Mail Profile',
    @principal_id = 0,
    @is_default = 1 ;
```

You can then make use of `sp_send_dbmail` to send email

```
EXEC msdb.dbo.[sp_send_dbmail]
    @profile_name = 'Database Mail Profile',
    @recipients = 'simon.timms@somedomain.com',
    @subject = 'Testing db email',
    @body = 'Hello friend, I'm testing the database mail'
```