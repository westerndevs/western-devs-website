---
title:  Stop Terraform Managing State for a Resource
authorId: simon_timms
date: 2021-07-30
originalurl: https://blog.simontimms.com/2021/07/30/stop-managing-resource
mode: public
---



Say you want to keep a resource but you want to stop terraform from managing it. You can ask terraform to update its state to forget about it. In my case I want terraform to forget it managing my Azure Static Web App because Terraform doesn't support all the options I need and will clobber the app. 

I can run this 

```bash
terraform state rm "azurerm_static_site.agentportal"
```

If I decide to start managing the state again I can just run a terraform import to manage it again. 