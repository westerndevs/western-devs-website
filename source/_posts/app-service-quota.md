---
title:  App Service Quota Issue 
authorId: simon_timms
date: 2023-03-04
originalurl: https://blog.simontimms.com/2023/03/04/app-service-quota
mode: public
---



I was deploying an app service in a new region today and ran into a quota issue. The error message was:

```
Error: creating Service Plan: (Serverfarm Name "***devplan" / Resource Group "***_dev"): web.AppServicePlansClient#CreateOrUpdate: Failure sending request: StatusCode=401 -- Original Error: Code="Unauthorized" Message="This region has quota of 0 instances for your subscription. Try selecting different region or SKU."
```

This was a pretty simple deployment to an S1 app service plan. I've run into this before and it's typically easy to request a bump in quota in the subscription. My problem today was that it isn't obvious what CPU quota I need to request. I Googled around and found some suggestion that S1 ran on A series VMs but that wasn't something I had any limits on.

Creating in the UI gave the same error

![](/images/2023-02-10-app-service-quota.md/2023-02-10-20-45-53.png))

I asked around and eventually somebody in the know was able to look into the consumption in that region. The cloud was full! Well not full but creation of some resources was restricted. Fortunately this was just a dev deployment so I was able to move to a different region and get things working. It would have been pretty miserable if this was a production deployment or if I was adding onto an existing deployment.