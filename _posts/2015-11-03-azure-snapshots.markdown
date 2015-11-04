---
layout: post
title:  "Doing Snapshots on Azure Virtual Machines"
date: 2015-11-03T17:30:00-08:00
comments: true
author: dylan_smith
---

I've always been frustrated that I can't do snapshots when I'm using VM's in Azure. Especially when I'm developing some deployment automation, I like to be able to try something out - and when it inevitably screws up - reset the VM to a snapshot and try again. 

We still can't do actual snapshots, but I've written some powershell that achieves the same goal.  It will grab a copy of the VHD file (this acts as the snapshot), then when we want to restore to snapshot we'll just swap out the VHD's.  The trick here is that Azure won't let you swap out the VHD for an existing VM, so we need to actually destroy the VM, swap out the VHD's, then recreate the VM using the existing VHD.

> Note: This is all done using ARM (Azure Resource Manager) style VM's.

If you want to try it out, here's a step-by-step to try it out:

First create a VM in Azure, and be sure to select Resource Manager as the deployment model:

![Create ARM VM](http://i.imgur.com/waHMXxG.png)

![VM Basics](http://i.imgur.com/601dKeE.png)

![Select VM Size](http://i.imgur.com/EjdOOxL.png)

![VM Settings](http://i.imgur.com/05cF86c.png)

After it's done processing we'll have a new Resource Group with 6 resources included:

![Resource Group](http://i.imgur.com/QKLize8.png)

One thing I like to do - that the wizard doesn't let you specify - is to assign a DNS name to the public IP that I'll use to connect to my VM.  You can set this in the configuration page for the Public IP resource.

![Set DNS](http://i.imgur.com/psVa4XE.png)

Lastly, I need to copy the Storage Account Access Key for use in the powershell.

![Retrieve Storage Key](http://i.imgur.com/yh9cgcp.png)

Now all we need to do is take the powershell below, and modify the values of the variables at the start to match the names you used when you created the VM/Resource Group.

The first time you run the script it will create the initial snapshot.  All subsequent times you run the script it will reset it to that snapshot.

{% highlight powershell %}
# Set variable values
$resourceGroupName = "DylanDemo"
$location = "West US"
$vmName = "DylanDemo"
$vmSize = "Standard_D1"
$vnetName = "DylanDemo"
$nicName = "dylandemo665"
$dnsName = "dylandemo"
$diskName = "DylanDemo"
$storageAccount = "dylandemo"
$storageAccountKey = "Enter Storage Key Here"
$subscriptionName = "MSDN MPN"
$publicIpName = "DylanDemo"

$diskBlob = "$diskName.vhd"
$backupDiskBlob = "$diskName-backup.vhd"
$vhdUri = "https://$storageAccount.blob.core.windows.net/vhds/$diskBlob"
$subnetIndex = 0

# login to Azure
Add-AzureAccount
Select-AzureSubscription -SubscriptionName $subscriptionName
Switch-AzureMode AzureResourceManager

# create backup disk if it doesn't exist
Stop-AzureVM -ResourceGroupName $resourceGroupName -Name $vmName -Force -Verbose

$ctx = New-AzureStorageContext -StorageAccountName $storageAccount -StorageAccountKey $storageAccountKey
$blobCount = Get-AzureStorageBlob -Container vhds -Context $ctx | where { $_.Name -eq $backupDiskBlob } | Measure | % { $_.Count }

if ($blobCount -eq 0)
{
  $copy = Start-AzureStorageBlobCopy -SrcBlob $diskBlob -SrcContainer "vhds" -DestBlob $backupDiskBlob -DestContainer "vhds" -Context $ctx -Verbose
  $status = $copy | Get-AzureStorageBlobCopyState 
  $status 

  While($status.Status -eq "Pending"){
    $status = $copy | Get-AzureStorageBlobCopyState 
    Start-Sleep 10
    $status
  }
}

# delete VM
Remove-AzureVM -ResourceGroupName $resourceGroupName -Name $vmName -Force -Verbose
Remove-AzureStorageBlob -Blob $diskBlob -Container "vhds" -Context $ctx -Verbose
Remove-AzureNetworkInterface -Name $nicName -ResourceGroupName $resourceGroupName -Force -Verbose
Remove-AzurePublicIpAddress -Name $publicIpName -ResourceGroupName $resourceGroupName -Force -Verbose

# copy backup disk
$copy = Start-AzureStorageBlobCopy -SrcBlob $backupDiskBlob -SrcContainer "vhds" -DestBlob $diskBlob -DestContainer "vhds" -Context $ctx -Verbose
$status = $copy | Get-AzureStorageBlobCopyState 
$status 

While($status.Status -eq "Pending"){
  $status = $copy | Get-AzureStorageBlobCopyState 
  Start-Sleep 10
  $status
}

# recreate VM
$vnet = Get-AzurevirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName

$pip = New-AzurePublicIpAddress -Name $publicIpName -ResourceGroupName $resourceGroupName -DomainNameLabel $dnsName -Location $location -AllocationMethod Dynamic -Verbose
$nic = New-AzureNetworkInterface -Name $nicName -ResourceGroupName $resourceGroupName -Location $location -SubnetId $vnet.Subnets[$subnetIndex].Id -PublicIpAddressId $pip.Id -Verbose
$vm = New-AzureVMConfig -VMName $vmName -VMSize $vmSize
$vm = Add-AzureVMNetworkInterface -VM $vm -Id $nic.Id
$vm = Set-AzureVMOSDisk -VM $vm -Name $diskName -VhdUri $vhdUri -CreateOption attach -Windows

New-AzureVM -ResourceGroupName $resourceGroupName -Location $location -VM $vm -Verbose
{% endhighlight %}