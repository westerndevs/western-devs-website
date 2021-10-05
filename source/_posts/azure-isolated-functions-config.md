---
title:  Configuration in Azure Isolated Functions 
authorId: simon_timms
date: 2021-10-05
originalurl: https://blog.simontimms.com/2021/10/05/azure-isolated-functions-config
mode: public
---



This is all done in the Program.cs. If you want to use the IOptions pattern which, let's face it, everybody does. Then you can start with creating your configuration classes (I like more than one so config for different parts of the app remain logical distinct). These are POCOs

```csharp
public class AuthConfiguration
{
    
    public string TenantId { get; set; }
    public string ClientId { get; set; }
    public string ClientSecret { get; set; }
    public string RedirectUrl { get; set; }
}
```

Then set this up in the host builder 


```csharp
var host = new HostBuilder()
            .ConfigureFunctionsWorkerDefaults()
            .ConfigureServices(container =>
            {
                container.AddOptions<AuthConfiguration>().Configure<IConfiguration>((settings, config) =>
                {
                    config.Bind(settings);
                });
            })
            .Build();
```

If this looks familiar it's because it totally is! All of this uses the generic .NET host so this same sort of pattern should work in most .NET apps now. 