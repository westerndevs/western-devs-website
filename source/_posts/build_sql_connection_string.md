---
title: # Building an SQL Azure Connection String using terraform
authorId: simon_timms
date: 2021-07-26
originalurl: https://blog.simontimms.com/2021/07/26/build_sql_connection_string
mode: public
---

## Building an SQL Azure Connection String using terraform

If you provision a database using terraform you often find that you need to get that connection string into app settings or key vault or something like that. To do that you first need to build it because the outputs from the database resource don't include it. 

From the database you want to export

```json
output "database_name" {
  value = azurerm_sql_database.database.name
}

```

Then when you actually build the string you want something like this:

```
database_connection_string    = "Server=tcp:${module.database.name}.database.windows.net,1433;Initial Catalog=${module.database.database_name};Persist Security Info=False;User ID=${var.database_user};Password=${var.database_password};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
```

Then you can push this to KeyVault or an App Service directly. 