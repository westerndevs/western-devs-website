---
title:  Which Key to use for Managed Identity in Keyvault
authorId: simon_timms
date: 2021-08-13
originalurl: https://blog.simontimms.com/2021/08/13/appliation-key-for-keyvault
mode: public
---



I have a terraform deployment which runs in azure pipeline. Azure pipelines is connected to Azure via a service connection. This service connection is registered as an application in the Azure AD of the Azure account. The problem I constantly run into is that I can't remember which id from the application should be granted keyvault access so the build pipeline can read and write to keyvault. 

```
resource "azurerm_key_vault_access_policy" "terraformaccess" {
  key_vault_id = azurerm_key_vault.keyvault.id

  tenant_id = local.tenant_id
  object_id = ???????????????????

  key_permissions = [
    "Get",
    "Create",
    "List",
    "Update",
    "Verify",
    "Delete",
    "WrapKey",
    "UnwrapKey"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set"
  ]

  storage_permissions = [
    "Get",
    "List",
    "Set",
    "Update"
  ]
}
```
Maybe the value is in the portal somewhere:

![](/images/2021-08-12-appliation-key-for-keyvault.md/2021-08-12-21-21-51.png))

Nope. 

It seems to be findable by doing either 

```powershell
Login-AzureRmAccount -SubscriptionId <your subscription id>;
$spn=(Get-AzureRmADServicePrincipal -SPN <the application id>);
echo $spn.Id
```

or 

```bash
 az ad sp list --spn <the application id>
```
Then look for `ObjectId`