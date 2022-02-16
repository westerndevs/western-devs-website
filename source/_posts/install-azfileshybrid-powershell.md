---
title:  Installing the AzFilesHybrid PowerShell Module
authorId: simon_timms
date: 2022-02-16
originalurl: https://blog.simontimms.com/2022/02/16/install-azfileshybrid-powershell
mode: public
---



If you don't do a lot of powershell then the instructions on how to install the AzFilesHybrid module can be lacking. Here is how to do it 

1. Download the module from https://github.com/Azure-Samples/azure-files-samples/releases
2. Unzip the file downloaded in step 1
3. Go into the folder and run the copy command 

```
./CopyToPSPath.ps1
```

4. Install the module with 
```
Install-Module -Name AzFilesHybrid -Force
```

With this module installed you can then run things like Join-AzStorageAccount to get a fileshare joined to the domain 

```
Join-AzStorageAccount -ResourceGroupName "rg-azfileshare" -StorageAccountName "sa-azfileshare" -DomainName "somedomain.com" -DomainUserName "jane" -DomainUserPassword "password"
```