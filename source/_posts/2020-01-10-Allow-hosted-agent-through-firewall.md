---
layout: post
title: Allow Azure DevOps Hosted Agents Through Firewall
authorId: simon_timms
date: 2020-01-10 9:00
originalurl: https://blog.simontimms.com/2020/01/10/2020-01-10-Allow-hosted-agents-through-firewall/
---

I have an on-premise (well in a third party data center but close enough) database which I'd like to update via a build in a hosted agent on Azure. We've done this before in Jenkins by just allowing a specific IP address through the firewall. However we're in the process of moving to DevOps for this build. Unfortunately, the hosted build agents don't have entirely predictable IP addresses. Every week Microsoft publishes a list of all the IP addresses in Azure. It is a huge json document and for our region (Central Canada) there are about 40 IP addresses ranges the build agent could be in. We want an automated way to update our firewall rules based on this list. 

<!-- more -->
To do so we make use of the Azure Powershell extensions. The commandlet Get-AzNetworkServiceTag is an API based way to get the IP ranges. You can then pass that directly into the firewall rules like so

```powershell
$addrs = ((Get-AzNetworkServiceTag -Location canadacentral).Values|Where-Object { $_.Name -eq "AzureCloud.canadacentral" }).Properties.AddressPrefixes
Set-NetFirewallRule -DisplayName "Allow SQL 1433 Inbound" -RemoteAddress $addrs
```

Running this once a week lets us keep the firewall up to date with the hosted agent ranges.

Bonus: If you want to see the remote addresses in your firewall rule currently then this will do it

```
 Get-NetFirewallRule -Direction Inbound -Action Allow -Enabled True -Verbose | ? DisplayName -like "Allow SQL 1433 Inbound" | Get-NetFirewallAddressFilter |Select-Object RemoteAddress -ExpandProperty RemoteAddress
```