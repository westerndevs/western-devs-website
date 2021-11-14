---
title:  App Services on VNET
authorId: simon_timms
date: 2021-11-14
originalurl: https://blog.simontimms.com/2021/11/14/app-services-on-vnet
mode: public
---



When setting up an app service, including azure functions,  you can have it reside on a vnet so it can access internal resources like a database. Often time though you'll run into some problems routing to the database, specifically because of DNS. There are some good tools for debugging the connection. 

First off you'll need to open a console to the app service. I do this using the kudu tools but I think the console exposed directly on the portal works too. The standard tools can't run in the restricted environment provided. However there are a couple of tools you can use in their place. 

NSLookup - > nameresolver.exe - run it with `nameresolver.exe blah.com` 
ping -> tcpping.exe - run it with `tcpping.exe blah.com:80`

If you're seeing DNS issues you can override the DNS server with the variables `WEBSITE_DNS_SERVER` and `WEBSITE_DNS_ALT_SERVER`. These two are entered in the app service config settings

One of the most typical problems I've encountered is that the app service isn't routing requests properly unless you add the app setting `WEBSITE_VNET_ROUTE_ALL=1`. 