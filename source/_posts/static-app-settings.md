---
title:  Deploying App Settings to an Azure Static Web App
authorId: simon_timms
date: 2021-07-26
originalurl: https://blog.simontimms.com/2021/07/26/static-app-settings
mode: public
---



Static web apps are pretty cool but certain parts of them feel like they are still a little raw. It is a newish product so I can understand that. I just wish the things that didn't get attention were something other that devops things. That's mostly because I'm so big on builds and repeatable processes. Being able to set app setting is one of the things I think falls through the cracks. 

The [docs](https://docs.microsoft.com/en-us/azure/static-web-apps/application-settings#:~:text=%20Using%20the%20Azure%20portal%20%201%20Navigate,7%20Click%20OK.%208%20Click%20Save.%20More%20) for statics web apps suggests two different ways of setting app settings. First through the portal which we can ignore right out the gate because it is manual. The second is through an `az` command that actually just exercises a REST endpoint. No Arm support, no terraform support, no bicep support, no azure powershell support... a long way to go. 

The az command takes in a specially formatted json file. My databse and connection string variables are set up as outputs from my terraform. Once I have them imported into my Azure DevOps build pipeline I use powershell to build the template file like so:

```powershell
$temp = gc api/api/local.settings.template.json | ConvertFrom-Json
$temp.properties.STORAGE_CONNECTION_STRING = "$(terraformOutput.storage_connection_string)"
$temp.properties.DATABASE_CONNECTION_STRING = "$(terraformOutput.database_connection_string)"
$temp | ConvertTo-json > api/api/local.settings.template.json
```

Now this needs to be passed up to azure using the `AzureCLI` task 

```yaml
  - task: AzureCLI@2
    inputs:
    azureSubscription: 'Azure Sub'
    scriptType: 'pscore'
    scriptLocation: 'inlineScript'
    inlineScript: |
        gc api/api/local.settings.template.json
        az rest --method put --headers "Content-Type=application/json" --uri "/subscriptions/6da8d6e6-41f1-xxxx-xxxx-xxxxxxxx/resourceGroups/dev-portal/providers/Microsoft.Web/staticSites/dev-portal/config/functionappsettings?api-version=2019-12-01-preview" --body @api/api/local.settings.template.json
```              