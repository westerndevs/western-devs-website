---
layout: post
title:  "PSA: Setting Up Containers in a VM in Windows Server 2016 Tech Preview 3"
date: 2015-08-19T16:38:59-04:00
categories:
comments: true
authorId: kyle_baley
alias: /psa-setting-up-containers-in-a-vm-in-windows-server-2016-tech-preview-3/
---

[Windows Server 2016 Tech Preview 3](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-technical-preview) has just been released and it has container support! There's [documentation](https://msdn.microsoft.com/virtualization/windowscontainers/quick_start/manage_docker) on it already to do basic stuff and it's easy to follow. So I'm going to <s>repeat it verbatim</s> quickly mention the one and only major issue I ran into.

I created a VM in Fusion for the server which went pretty smoothly. When presented with a list of operating systems, I selected Windows Server 2012 and it installed fine from the ISO file. After that, I started on the documentation and at the step where you run the ContainerSetup.ps1 powershell script, I got hit with an error:

    New-NetNat : No matching interface was found for prefix (null).
    At C:\ContainerSetup.ps1:247 char:5
    New-NetNat -Name ContainerNAT -InternalIPInterfaceAddressPrefix $ ...
    CategoryInfo : NotSpecified (MSFT_NetNat:root/StandardCimv2/MSFT_NetNat) [New-NetNat], CimException
    FullyQualifiedErrorId : Windows System Error 1169,New-NetNat

![New-NetNat error](http://i.imgur.com/W6BxfIE.png)

This tripped me up for a while for a few reasons:

1) I'm not crazy familiar with PowerShell
2) Nothing came up for the error message in the Bingoogle
3) InternalIPInterfaceAddressPrefix doesn't even appear in the documentation for [New-NetNat](https://technet.microsoft.com/en-us/library/dn283361(v=wps.630).aspx)

The answer, which came to me in a [rubber ducking](https://en.wikipedia.org/wiki/Rubber_duck_debugging) episode as I typed on a question on the forums, was in the VM's network configuration in VMWare Fusion:

![Network settings](http://i.imgur.com/nzfzr4X.png = 200x)

By default, VMs get created with the "Share with my Mac" setting. Changing this to Autodetect allowed the script to continue.

By that time, I had discovered that an Azure VM image already exists for Server 2016 Tech Preview 3 and even with the Containers Feature already enabled. So that's as far as I ventured with the VM.