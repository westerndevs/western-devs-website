---
layout: podcast
title: Building APIs
categories: podcasts
comments: true
podcast:
  filename: westerndevs-building-apis.mp3
  length: '39:28'
  filesize: 37892683
  libsynId: 4435502
participants:
  - kyle_baley
  - amir_barylko
  - dave_white
  - dylan_smith
  - simon_timms
music:
  - title: Doctor Man
    artist: Johnnie Christie and the Boats
    url: 'https://www.youtube.com/user/jwcchristie'
links:
  - 'Your API versioning is wrong|https://www.troyhunt.com/your-api-versioning-is-wrong-which-is/'
  - 'Stripe API|https://stripe.com/docs/api'
  - 'Azure ARM Template API|https://azure.microsoft.com/en-us/documentation/articles/resource-group-authoring-templates/'
  - 'How Microsoft Lost the API War|http://www.joelonsoftware.com/articles/APIWar.html'
  - 'HTTPS as a ranking signal|https://webmasters.googleblog.com/2014/08/https-as-ranking-signal.html'
  - 'AppVeyor|https://www.appveyor.com/'
  - 'SignalR|http://www.asp.net/signalr'
  - 'IFTTT|https://ifttt.com'
  - 'Zapier|https://zapier.com'
  - 'Token-based authentication|https://scotch.io/tutorials/the-ins-and-outs-of-token-based-authentication'
  - 'OAuth2|http://oauth.net/2/'
  - 'Authenticating in TFS with personal access tokens|https://www.visualstudio.com/en-us/docs/setup-admin/team-services/use-personal-access-tokens-to-authenticate'
date: 2016-06-02 09:58:48
excerpt: "The Western Devs discuss the ins and outs of building APIs"
---

### Synopsis

* What is an API?
* Clarifying "public" with respect to APIs
* Why build an API?
* APIs as a means of breaking down components and compartmentalizing data
* API design considerations
* The effect of microservices
* Versioning an API
  * Maintaining multiple versions
  * Using a message upgrade service
  * Only adding to the API
  * The cost of maintaining backward compatibility
  * Using speed as an incentive to get customers to upgrade to a later version
* SignalR/Websockets
* Balancing data between an API and a webhook
* Services that integrate with APIs (e.g. IFTTT, Zapier)
* Native integration with 3rd party services
* Authentication
  * Token-based
  * OAuth2
  * Application-specific tokens
  * Expiring tokens
  * Applying permissions to tokens
