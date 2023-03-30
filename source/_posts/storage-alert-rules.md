---
title:  Alerting on Blob Storage Throttling 
authorId: simon_timms
date: 2023-03-30
originalurl: https://blog.simontimms.com/2023/03/30/storage-alert-rules
mode: public 
---



Blob storage is the workhorse of Azure. It is one of the original services and has grown with the times to allow storing data in a variety of formats. It is able to scale perhaps not to the moon but certainly to objects in low earth orbit(LEO). 

One of my clients has a fair bit of data stored in a file share hosted in Azure Storage. They do nightly processing on this data using a legacy IaaS system. We were concerned that we might saturate the blob storage account with our requests. Fortunately, there are metrics we can use to understand what's going on inside blob storage. Nobody wants to monitor these all the time so we set up some alerting rules for the storage account. 

Alert rules can easily be created by going to the file share in the storage account and clicking on metrics. Then in the top bar click on `New Alert Rule`

The typical rules we applied were 
1. Alerting if we reach a certain % of capacity. We set this to about 90%
![](/images/2023-03-30-storage-alert-rules.md/2023-03-30-07-32-46.png))
2. Alerting if we see the number of transactions fall outside a typical range. We used a dynamic rule for this to account for how the load on this batch processing system changes overnight. 
![](/images/2023-03-30-storage-alert-rules.md/2023-03-30-07-35-25.png))

However there was one additional metric we wanted to catch: when we have hit throttling. This was a bit trickier to set up because we've never actually hit this threshold. This means that the dimensions to filter on don't actually show up in the portal. They must be entered by hand. 

These are the normal values we see
![](/images/2023-03-30-storage-alert-rules.md/2023-03-30-07-38-07.png))

By clicking on add custom value we were able to add 3 new response codes 

* ClientAccountBandwidthThrottlingError
* ClientShareIopsThrottlingError
* ClientThrottlingError

![](/images/2023-03-30-storage-alert-rules.md/2023-03-30-07-40-59.png))

With these in place we can be confident that should these ever occur we'll be alerted to it