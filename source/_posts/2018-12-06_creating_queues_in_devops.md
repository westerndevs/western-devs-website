layout: post
title: Creating Storage Queues in Azure DevOps
authorId: simon_timms
date: 2018-12-06 13:00
originalurl: https://blog.simontimms.com/2018/12/06/2018-12-06_creating_queues_in_devops/

---

Storage Queues are one of the original pieces of Azure dating back about a decade now. They are great for deferring work to later or spreading it out over a bunch of consumers. If you're following best practices for DevOps you'll know that the creation of your queues should be done in code. In some cases you can create the queues on application startup but in serverless scenarios there often is no startup code so the responsibility of creating queues falls to your deployment process. Let's look at how to do that on Azure DevOps

<!--more-->

Your first instinct might be to use your ARM templates to build queues. This makes great sense - the storage account is defined in the ARM template so why not also define the queues? Because you can't! 

There is a [request open to add that functionality](https://feedback.azure.com/forums/281804-azure-resource-manager/suggestions/9306108-let-me-define-preconfigured-blob-containers-table) but after 3 years it remains unanswered. Talking to some Azure engineers at Microsoft it seems like the approach they would like people to take is to build the queue in the application. Problem with that is that now your application needs to have rights to create queues instead of just right to write to or read from the queue. You might also not have an appropriate place to put startup code - for instance Azure Functions don't have a good way to run code on startup. Same deal with logic apps.

The fact that creating storage queues is not officially supported in ARM templates is baloney and the argument that this is an application level create queue to do is proof that parts of Microsoft still doesn't get DevOps. 

This means we have to plug something into the pipeline to create the queues. I quite like the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest) which is a great little command line tool for interacting with Azure. You can add in the Azure CLI task in Azure DevOps, hook up the subscription and the give it an inline script like so:

```
call az storage queue create -n "awesome-queue-1" --connection-string "$(storageAccountConnectionString)"
```

If you're using a Windows build agent then you need to include the `call` to ensure that multiple lines are executed. If you're on a Linux agent then `call` can be omitted.

That connection string can be exported from your ARM template as an output parameter and then sucked into the DevOps variables using [ARM Outputs](https://github.com/keesschollaart81/vsts-arm-outputs).