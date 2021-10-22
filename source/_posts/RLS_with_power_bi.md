---
title: # Using RLS in Power BI Embedded
authorId: simon_timms
date: 2021-10-22
originalurl: https://blog.simontimms.com/2021/10/22/RLS_with_power_bi
mode: public
---

## Using RLS in Power BI Embedded

Power BI is a funny animal. On some levels it is a logical successor to SSRS but on other levels it is a totally different beast. One of the ways it differs greatly from SSRS is in handling parameters, especially secure parameters. When embedding an SSRS report you could specify the parameter value in a secure fashion and then now show the selector to end users.

In many cases there is a need to use row level security (RLS) to restrict the data that a user can see in Power BI. There are a myriad of ways to do this wrong and I think I've explored most of them over the last few days. There is also at least one way that works. 

A tempting approach is to use a filter. These can be applied at render time in the browser by adding to the config when embedding the report. 

```javascript
const config = {
      visualName: '',
      type: 'report',
      accessToken: token, 
      embedUrl: token.embedUrl,
      tokenType: powerbi.models.TokenType.Embed,
      permissions: permissions,
      // 👇 filters
      filters: [
        {
          $schema: "http://powerbi.com/product/schema#basic",
          target: {
              table: "monthlyProducts",
              column: "userId"
          },
          operator: "In",
          values: ["stimms"]
        }
      ],
      // ☝️
      settings: {
        panes: {
          filters: {
            visible: true,
          },
          pageNavigation: {
            visible: true,
          },
        },
      },
    }
```

This class of parameter is fine for providing filters that can be updated later by the user. However, it should not be used for parameters that require some degree of security like a user name. These parameters are easily changed and, unless your parameter are in some way cryptographically secure there is a good chance you're introducing a broken access control - [#1](https://owasp.org/Top10/A01_2021-Broken_Access_Control/) on the [OWASP top 10](https://owasp.org/www-project-top-ten/). 

Instead of this approach you can use the manage roles functionality in Power BI. 

![](/images/2021-10-22-RLS_with_power_bi.md/2021-10-22-15-55-31.png))

This functionality is designed to provide high level filters for data. A lot of the examples I see are for things like restricting a user in the `East` region from seeing the data of a user in the `West` region. This is done by assigning a role to that user when generating the embedding token. Then you'd set up a role for each region (see 1) and apply a filter expression to your tables so the only records with a region of `East` would show up.

![](/images/2021-10-22-RLS_with_power_bi.md/2021-10-22-15-59-46.png))

This is a simplistic and somewhat tiresome approach to adding a role mapping. What if a new region like `SouthEast` is introduced? What isn't, perhaps, as clear is that DAX expression can contain dynamic functions like `UserName()` which make filtering more powerful. 

What I settled on for my filtering was to have a single role which I enforce at the embedded token generation level and then filter my data by the UserName() which I also set at the embedded token level. Because these are set at the embedded token generation time which occurs on the server I can be confident that I'm not providing a way for somebody to view data they shouldn't. 

The code for generation looks like this:

```csharp
var tokenRequest = new GenerateTokenRequestV2(
                    reports: new List<GenerateTokenRequestV2Report>
                    {
                        new GenerateTokenRequestV2Report(reportId)
                    },
                    datasets: new List<GenerateTokenRequestV2Dataset> { new GenerateTokenRequestV2Dataset(report.DatasetId) },
                    identities: new List<EffectiveIdentity> { new EffectiveIdentity(user.ContactId.ToString(),
                                                                roles: new List<string> { "ContactId" },
                                                                datasets: new List<String>{report.DatasetId })
                    }
                );
var embedToken = await client.EmbedToken.GenerateTokenAsync(tokenRequest);
```

In this particular case the data I was returning from the database could be accessed by a number of different people depending on to which group they belonged. Initially I tried crossing the data against the user/group matrix but the cardinality of the resulting set was in the billions and totally overwhelmed both SQL Server and Power BI. Instead what I did was pull in the user/group matrix and the dataset that exposed the group id. In Power BI I did a merge of the datasets along with applying the row level filtering. This was necessary because, as far as I know, there is no way to pass the user name down to the actual query running against the server. 

With all this in place I got good security and good performance. But, wow, did it take me a long time to get there. 