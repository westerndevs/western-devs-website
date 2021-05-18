---
title:  Importing a backup into azure 
authorId: simon_timms
date: 2021-05-18
originalurl: https://blog.simontimms.com/2021/05/18/importing-tde-encrypted-backup
mode: public
---



Let's say you're moving an encrypted backup into Azure. The encryption was set up like this 

```SQL
CREATE CERTIFICATE BackupKey   
   ENCRYPTION BY PASSWORD = 'a password that''s really strong here'  
   WITH SUBJECT = 'test1backup',   
   EXPIRY_DATE = '20220101';  
GO  
```

Now we need to export this certificate which can be done with 

```sql
BACKUP CERTIFICATE BackupKey TO FILE = 'c:\temp\backupkey.cer'
WITH PRIVATE KEY (
	FILE = 'c:\temp\backupkey.pvk',
	DECRYPTION BY PASSWORD = 'a password that''s really strong here',
	ENCRYPTION BY PASSWORD = 'A strong password for the certificate' )
```

Now we have two file which contain the public and private keys. We need to combine these into something that Azure Key Vault can understand and this something is a .pfx file. There is a tool called `pvk2pfx` which can be used for this task and it is found in the Windows Enterprise Driver Kit https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk. It is also installed as part of visual studio. On my machine it was in `C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x86\pvk2pfx.exe`

Run this command to combine them

```powershell
& "C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x86\pvk2pfx.exe" -pvk C:\temp\backupkey.pvk -pi 'A strong password for the certificate' -spc C:\temp\backupkey.cer -pfx c:\temp\backupkey.pfx
```

Next up we need to import this key into azure keyvault. This can be done using the GUI or the command line tools. Everybody likes a pretty picture so let's use the Portal. Click into the key vault and then under certificates
![](/images/2021-05-18-importing-tde-encrypted-backup.md/2021-05-18-14-00-09.png))

Then click on `Generate/Import` and fill in the form there selecting the `.pfx` file created above.
![](/images/2021-05-18-importing-tde-encrypted-backup.md/2021-05-18-12-55-32.png))

The password will be the same one you used when exporting from SQL server. Once the certificate is imported it should be available to anybody or any application with access to certificates in key vault.

You can open up SQL Server Management Studio and in there add a new certificate selecting the certificate from the Key Vault connection

![](/images/2021-05-18-importing-tde-encrypted-backup.md/2021-05-18-13-58-27.png))