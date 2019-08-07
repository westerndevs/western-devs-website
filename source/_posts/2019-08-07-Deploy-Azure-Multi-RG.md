---
layout: post
title: Deploying Azure resources to multiple resource groups
categories:
  - Azure
date: 2019-08-07 14:49:25
tags:
  - Azure
  - ARM
  - Configuration-as-Code
authorId: tyler_doerksen

---

## Advanced ARM Template Development

Azure Resource Manager (ARM) templates provide an excellent, built-in resource configuration and deployment solution. You can find a wealth of templates for deploying anything from a [Wordpress site on Azure App Service](https://github.com/Azure/azure-quickstart-templates/tree/master/wordpress-app-service-mysql-inapp), to a full [HDInsight cluster on a private VNET](https://github.com/Azure/azure-quickstart-templates/tree/master/101-hdinsight-secure-vnet).

<!-- more -->

Often I work with customers that need to go beyond the basics of ARM Templates, deploying complex solutions across multiple Resource Groups, with different RBAC permissions.

So here I will share some tips-and-tricks you may find helpful when authoring complex templates.

## Deploying to multiple Azure Resource Groups

First, a very common question, and the title of this post, deploying Azure resources across multiple Resource Groups. You can accomplish this in 3 ways:

1. Deploy multiple times using a script or deployment engine (Azure DevOps Pipeline)
2. Deploy to a "primary" Resource Group [with nested templates deploying to other Resource Groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-cross-resource-group-deployment "Deploy Azure resources to more than one subscription or resource group")
3. Use a [Subscription-level resource template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/deploy-to-subscription "Create resource groups and resources at the subscription level") to define all Resource Groups and nested templates

### Using a script (#1)

This is by far the simplest solution, however it is also the most error-prone. You will have to code features that the Azure deployment system would otherwise handle for you, like dependencies, failures, and ordering. Most likely need a script, however it is best to keep it as simple as possible, adding all of the configuration into the ARM Template.

### Resource Group deploying other Resource Groups (#2)

This is accomplished using the `"resourceGroup"` property which you can set on the `"Microsoft.Resources/deployments"` type, otherwise known as a nested template. Overall this is a minimal change if you are already using nested templates.

You can also deploy to multiple subscriptions using the `"subscriptionId"` property.

There are a couple of gotchas here, one is that the child Resource Groups need to exist before the nested deployment (just like how you need to define an existing RG when executing a template deployment). You can either script the creation of all of the RGs before running the deployment on the "primary" RG, or use the `"Microsoft.Resources/resourceGroups"` resource type, with the `dependsOn` property on the nested template.

Here is an example

```json
{
    "type": "Microsoft.Resources/resourceGroups",
    "apiVersion": "2018-05-01",
    "location": "[parameters('location')]",
    "name": "[parameters('msiResourceGroup')]",
    "properties": {}
},
{
    "name": "msiDeployment",
    "type": "Microsoft.Resources/deployments",
    "apiVersion": "2017-05-10",
    "resourceGroup": "[parameters('msiResourceGroup')]",
    "dependsOn": [
        "[resourceId('Microsoft.Resources/resourceGroups/', parameters('msiResourceGroup'))]"
    ],
    "properties": { ... }
}
```

Also, depending on how you nest templates, the `resourceGroup()` function will behave differently. If you have an embedded template `"template": {}` the `resourceGroup()` function will refer to the parent RG. Alternatively, if you have a linked template `"templateLink": { "uri": "..."}` the `resourceGroup()` function will refer to the child RG. The same applies to the `subscription()` function.

### Subscription-level Templates (#3)

This may be my preferred method of deploying complex, multi-RG solutions. Most of the concepts are the same as cross-RG deployments, however there is no "primary" RG. With this method you can deploy to a completely blank Subscription, which is why this is often used in combination with [Azure Blueprints](https://docs.microsoft.com/en-us/azure/governance/blueprints/overview "Overview of the Azure Blueprints service") as a "Subscription Factory" pattern.

To author Subscription Templates, you need to use a different template schema `https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#` and execute the deployment using the `New-AzDeployment` or `az deployment create` command.

Here is an Azure docs article for the details: [Create resource groups and resources at the subscription level](https://docs.microsoft.com/en-us/azure/azure-resource-manager/deploy-to-subscription "Create resource groups and resources at the subscription level")

The Subscription template will be fairly light, with most of the heavy lifting in the nested templates. There are a few functions that are not available in the Subscription Template, like `resourceGroup()` which means you can't use `resourceGroup().location` as a default deployment location.

You will need to add a `"location"` parameter to the template, and use the value when creating the Resource Groups.

Here is an example:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
    "contentVersion": "1.0.0.1",
    "parameters": { 
        "hdiResourceGroup": {
            "type": "string",
            "defaultValue": "DL-HDI"
        },
        "msiResourceGroup": {
           "type": "string",
           "defaultValue": "DL-MSI"
        },
        "location": {
            "type": "string",
            "defaultValue": "westus2"
        } ...
    },
    "variables": {...},
    "resources": {
        {
            "type": "Microsoft.Resources/resourceGroups",
            "apiVersion": "2018-05-01",
            "location": "[parameters('location')]",
            "name": "[parameters('hdiResourceGroup')]",
            "properties": {}
        },
    }
    ....
}
```

## Extra Tip: Using the `templateLink.uri` property

I am not a big fan of using additional parameters for Nested Template URLs and SAS Tokens. You may have seen them in examples with underscores in front, like `"_sasToken"` or `"_templateRoot"`

When you create a deployment using a template link URL (on `raw.githubusercontent.com` or Azure Blob Storage) you have access to a `templateLink` property on [the Deployment model](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-functions-deployment#deployment "Deployment functions for Azure Resource Manager templates")

If you are using public urls, you can just use the `uri()` function for nested templates.

`"msiTemplate": "[uri(deployment().properties.templateLink.uri, 'dl-msi.json')]`

If you want to [secure the templates using Azure Blob Storage SAS Tokens](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-powershell-sas-token "Deploy private Resource Manager template with SAS token and Azure PowerShell"), you can use some String functions to pull the SAS token out of the TemplateLink property.

For example:

```json
"variables": {
  "templateRoot":"[deployment().properties.templateLink.uri]",
  "hasToken":"[not(equals(indexOf(variables('templateRoot'),'?'), -1))]",
  "sasToken":"[if(variables('hasToken'),substring(variables('templateRoot'),indexOf(variables('templateRoot'),'?')),'')]",
  "msiTemplate": "[concat(uri(deployment().properties.templateLink.uri, 'dl-msi.json'), variables('sasToken'))]",
}

```

Note that this example supports both public and access token URLs, which adds complexity with conditional statements. I tried to keep it as simple as possible.

This practice assumes that you are deploying the templates before running any deployments. This does not work with local files or inline JSON deployments.