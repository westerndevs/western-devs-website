---
title:  Azure KeyVault Reference Gotcha
authorId: simon_timms
date: 2023-03-04
originalurl: https://blog.simontimms.com/2023/03/04/azure-keyvaul-reference-gotcha
mode: public
---



I was working on a deployment today and ran into an issue with a keyvault reference. In the app service the keyvault reference showed that it wasn't able to get the secret. The reference seemed good but I wasn't seeing what I wanted to see which was a couple of green checkmarks

![](/images/2023-03-03-azure-keyvaul-reference-gotcha.md/2023-03-03-21-10-36.png))

The managed identity on the app service had only GET access to the keyvault. I added LIST access and the reference started working. I'm not sure why this is but I'm guessing that the reference is doing a LIST to get the secret and then a GET to get the secret value.