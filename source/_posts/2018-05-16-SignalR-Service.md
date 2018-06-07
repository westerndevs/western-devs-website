---
layout: post
title: "SignalR as a Service"
tags:
  - SignalR
  - Azure
  - Serverless
categories:
  - Development
authorId: simon_timms
date: 2018-05-17 13:10:00
excerpt: The SignalR service which recently entered public preview in Azure closes the loop on building rich serverless applications.
---

I've been pretty impressed with the Azure Functions over the last year or so. The team started off pretty far behind AWS Lambda but they're accelerating quickly and are, in many ways, leading. A while back I was playing with the idea of building an entire web application in a serverless fashion. Most of the problems have been solved. 

The application would be a single page application with the content served out from blob storage. The blob storage is [fronted by Azure CDN](https://docs.microsoft.com/en-us/azure/cdn/cdn-create-a-storage-account-with-cdn) to enable custom domains and HTTPS. The API which the application talks to is all handled by Azure functions. Logging into the application is handled by Azure Active Directory and an [OAuth 2.0 implicit authorization workflow](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-authentication-scenarios#single-page-application-spa) for which there is even [a library](https://github.com/AzureAD/azure-activedirectory-library-for-js). The token from the authorization allows calling the function directly from the browser. 

For most applications this would be enough but there is a certain class of application which needs a little bit more: real time updates. There are tons of applications which would benefit from this sort of interaction. Yes there are chat applications and mapping applications which benefit from this but I actually think the scope of applications which benefit from real time updates is larger than that. 

CQRS+ES or microservice based applications struggle with how to build user interfaces which are resilient to the possibility that command will be executed in a delayed fashion. Over the years I've played with a few models of how to build the user interface without finding a really satisfactory solution. If events from the command handlers could be published out to browsers directly then I think opens up some really nice interaction models. Anything which lowers the bar to adopting applications which are resilient to the delays inherent in out of process microservices is a great step towards building better applications in general.  

Functions don't lend themselves to the kinds of long running processes necessary to hold open a web socket or doing long poling. It would be expensive and likely wouldn't scale all that well. 

That's why I'm so excited about the new [SignalR service](): it is the missing puzzle piece in building out distributed applications which can scale both in an upwards and downwards fashion and are highly reliable. The case for building server side applications in something like ASP.NET or Rails is getting narrower and narrower. 

Death to managing servers. Long live serverless.