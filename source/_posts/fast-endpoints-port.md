---
title:  Fast Endpoints Listen Port
authorId: simon_timms
date: 2024-10-12
originalurl: https://blog.simontimms.com/2024/10/12/fast-endpoints-port
mode: public
---



In order to set the listening port for Fast Endpoints you can use the same mechanism as a regular ASP.NET application. This invovles setting the Urls setting in the appsettings.json file. My file looks like this:

```
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "Urls": "http://0.0.0.0:8080",
  "AllowedHosts": "*"
}
```
