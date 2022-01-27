---
title:  Purge CDN in DevOps
authorId: simon_timms
date: 2022-01-27
originalurl: https://blog.simontimms.com/2022/01/27/purge-cdn-in-devops
mode: public
---



In order to purge a cache in the build pipeline you can use some random task that some dude wrote or you can just use the Azure CLI.

Here is an example of what it would look like to purge the entire CDN top to bottom


```yml
- task: AzureCLI@2
  displayName: 'Invalidate CDN Cache'
  inputs:
    azureSubscription: 'Azure'
    scriptType: 'batch'
    scriptLocation: 'inlineScript'
    inlineScript: 'az cdn endpoint purge --content-paths "/*"  -n devascacdnendpoint -g devasca-rg --no-wait --profile-name devascacdn'
```