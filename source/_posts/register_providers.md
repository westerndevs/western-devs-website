---
title:  Registering Terraform Providers
authorId: simon_timms
date: 2022-08-12
originalurl: https://blog.simontimms.com/2022/08/12/register_providers
mode: public
---



If you're setting up a new Terraform project on Azure you might find yourself needing to register providers if you're running with an identity that doesn't have wide ranging access to the subscription. I ran into this today with the error 

```

│ Error: Error ensuring Resource Providers are registered.
│ 
│ Terraform automatically attempts to register the Resource Providers it supports to
│ ensure it's able to provision resources.
│ 
│ If you don't have permission to register Resource Providers you may wish to use the
│ "skip_provider_registration" flag in the Provider block to disable this functionality.
│ 
│ Please note that if you opt out of Resource Provider Registration and Terraform tries
│ to provision a resource from a Resource Provider which is unregistered, then the errors
│ may appear misleading - for example:
│ 
│ > API version 2019-XX-XX was not found for Microsoft.Foo
│ 
│ Could indicate either that the Resource Provider "Microsoft.Foo" requires registration,
│ but this could also indicate that this Azure Region doesn't support this API version.
│ 
│ More information on the "skip_provider_registration" flag can be found here:
│ https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#skip_provider_registration
│ 
│ Original Error: Cannnot register providers: Microsoft.StoragePool. Errors were: Cannot register provider Microsoft.StoragePool with Azure Resource Manager: resources.ProvidersClient#Register: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthorizationFailed" Message="The client '************' with object id ''************'' does not have authorization to perform action 'Microsoft.StoragePool/register/action' over scope '/subscriptions/***' or the scope is invalid. If access was recently granted, please refresh your credentials.".
│ 
│   with provider["registry.terraform.io/hashicorp/azurerm"],
│   on environment.tf line 21, in provider "azurerm":
│   21: provider "azurerm" {
```

The account running terraform in my github actions pipeline is restricted to only have contributor over the resource group into which I'm deploying so it's unable to properly set up providers. Two things needed to fix it: 

  1. Tell terraform to not try to register providers 
  2. Register the providers manually 

  For 1 the provider block in the terraform file needs to be updated to look like 

```
  provider "azurerm" {
    features {
    }
    skip_provider_registration = true
}
```

For 2 it requires logging into the azure portal and registering the providers manually. Go to the subscription and select `Resource Providers` then search for the one you need, select it and hit `Register`. In my case the provider was already registered and the problem was just Terraform's attempt to register it without sufficient permission. 

![](/images/2022-08-11-register_providers.md/2022-08-11-07-07-29.png))


```