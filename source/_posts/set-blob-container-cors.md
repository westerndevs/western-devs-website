---
title:  Setting Container Cors Rules in Azure
authorId: simon_timms
date: 2024-05-24
originalurl: https://blog.simontimms.com/2024/05/24/set-blob-container-cors
mode: public
---



This week I'm busy upgrading some legacy code to the latest version of the Azure SDKs. This code is so old it was using packages like `WindowsAzure.Storage`. Over the years this library has evolved significantly and is now part of the `Azure.Storage.Blobs` package. What this code I was updating was doing was setting the CORS rules on a blob container. These days I think I would solve this problem using Terraform and set the [blob properties](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) directly on the container. But since I was already in the code I figured I would just update it there.

So what we want is to allow anybody to link into these and download them with a GET 

```csharp
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
...
var bsp = new BlobServiceProperties { HourMetrics = null, MinuteMetrics = null, Logging = null };
bsp.Cors.Add(new BlobCorsRule
{
    AllowedHeaders =  "*",
    AllowedMethods = "GET",
    AllowedOrigins = "*",
    ExposedHeaders = "*",
    MaxAgeInSeconds = 60 * 30 // 30 minutes
});

// from a nifty little T4 template
var connectionString = new ConnectionStrings().StorageConnectionString;
BlobServiceClient blobServiceClient = new BlobServiceClient(connectionString);
blobServiceClient.SetProperties(bsp);
```

Again, in hindsight I feel like these rules are overly permissive and I would probably want to lock them down a bit more. 