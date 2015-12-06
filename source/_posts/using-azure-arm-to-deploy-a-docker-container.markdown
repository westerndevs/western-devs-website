---
layout: post
title:  Using Azure ARM to Deploy a Docker Container
date: 2015-08-24T11:13:00-08:00
categories:
comments: true
authorId: dylan_smith
---

If you’ve been following the WesternDevs blog you’ll have seen a few posts lately about our adventures with infrastructure for our blog with Jekyll/Docker.

  * [Docker on Windows 10 Problems](http://www.westerndevs.com/docker-on-windows-10-problems/)
  * [Getting Docker Running on Windows 10](http://www.westerndevs.com/getting-docker-running-on-windows-10/)
  * [Docker and Western Devs](http://www.westerndevs.com/docker-and-western-devs/)

We decided to use Jekyll to host our blog, which most of us had never used before.  All of us need a way to fire up a Jekyll instance to test our changes (even simple things like how a new post will render).  Jekyll is really made for Linux, and most of us run Windows.  Although [Jekyll can run on windows in theory](http://jekyll-windows.juthilo.com/), we have struggled to get it to work.  Amir came to the rescue, and created a [Docker image that includes Jekyll](https://hub.docker.com/r/abarylko/western-devs/) configured according to our needs.

Now we have a new problem – most of us haven’t used Docker before.  We had some struggles, just getting Docker up and running and configured on Windows took a little bit of work for those of us that hadn’t used it before.  Those of us using Windows 10 discovered there were [additional challenges getting Docker running](Docker on Windows 10 Problems).  And for me personally, I do all my work in VM’s (either local VM’s, or Azure VM’s) and I didn’t want to install Docker/VirtualBox on my host OS, and I discovered that you can’t install Docker/VBox inside a Hyper-V Windows VM.

I decided I was going to get something running in Azure, and I had an additional goal of making what I did repeatable and automated so that my fellow Western Devs could easily do what I did.  I’ve been doing *a lot* of work with Azure ARM Templates lately, so that was the approach I took.  I noticed there is a pre-existing image with Ubuntu available, and there is a Docker VM Extension that you can apply during provisioning that will install/configure Docker, and it can use Docker Compose to spin up one or more containers too.

I created the JSON ARM Template, and a simple PowerShell script to deploy it.  Now any of my fellow WesternDevs can simply run a PS1 script, get prompted for a few pieces of info (azure credentials, azure subscription, github branch name, resource group name), and ~10 mins later they will have a new VM in Azure, with Docker installed, our WesternDevs image deployed, and our Jekyll site up and running with the code from their branch.  Then they can bring it up in a web browser and test out their changes before merging with Master.  When they’re done they can delete the Azure resource group if they wish, or keep it around for future testing.


## The Gory Details

If you’ve never used Azure ARM Templates before, it’s a JSON file that describes a set of Azure Resources and their configurations.  You can use a PowerShell cmdlet to give the JSON to Azure, and it will spin up a new Resource Group and a bunch of new resources based on what is described in the JSON.  For the WesternDevs template the JSON describes the following resources:

  * Storage Account
  * Public IP Address
  * Virtual Network
  * Network Interface
  * Network Security Group
  * Virtual Machine
  * VM Extension – DockerExtension

The full JSON file is included at the end of this post.  It can also be [found on GitHub](https://github.com/westerndevs/western-devs-website/tree/source/_azure).  Some of the configuration that is described in the JSON template includes:

  * The Network Security Group exposes port 22 for SSH, and port 4000 for HTTP (this is what our Jekyll/Docker is configured to use)
  * The VM is created from an image in the Azure Gallery provided by Canonical that has Ubuntu 15.04 on it.

VM Extensions are additional components that can be applied to your VM as part of the provisioning process.  There is an extension available called DockerExtension that will install and configure Docker for you as part of the provisioning process.  Here is the relevant part of the template:

{% codeblock lang:json %}
{
  "type": "Microsoft.Compute/virtualMachines/extensions",
  "name": "[concat(variables('vmName'),'/', variables('extensionName'))]",
  "apiVersion": "2015-05-01-preview",
  "location": "[variables('location')]",
  "dependsOn": [
    "[concat('Microsoft.Compute/virtualMachines/', variables('vmName'))]"
  ],
  "properties": {
    "publisher": "Microsoft.Azure.Extensions",
    "type": "DockerExtension",
    "typeHandlerVersion": "1.0",
    "autoUpgradeMinorVersion": true,
    "settings": {
      "compose": {
        "wddocker": {
          "image": "abarylko/western-devs:v1",
          "ports": [
            "4000:4000"
          ],
          "stdin_open": true,
          "command": "[concat('bash -c \"git clone https://github.com/westerndevs/western-devs-website.git && cd western-devs-website && git checkout ', parameters('branchName'), ' && sed -i s/www.westerndevs.com/', variables('dnsNameForPublicIP'), '.westus.cloudapp.azure.com:4000/g _config.yml && bundle install && jekyll serve --host 0.0.0.0 --force_polling\"')]"
        }
      }
    }
  }
}
{% endcodeblock %}

This tells it to apply the DockerExtension to the VM previously created.  Additionally it uses Docker Compose to allow you to specify one or more Docker containers that it will pull down from DockerHub, deploy into Docker, allow you to specify configuration such as ports to map to the host, and allow you to run command(s) on the docker image.

In the template above we tell it to grab the Docker image abarylko/western-devs:v1 which was created by my friend [Amir Barylko](http://www.westerndevs.com/bios/amir_barylko/) and already has Jekyll installed.  Then we tell it to map port 4000 from the docker container to port 4000 on the host Linux VM.  Lastly we give it a few bash commands to run on the docker container when it starts up:

  * git clone https://github.com/westerndevs/western-devs-website.git
  * cd western-devs-website
  * git checkout [branchName]
  * sed –i s/www.westerndevs.com/[VmDns].westus.cloudapp.azure.com:4000/g _config.yml
  * bundle install
  * jekyll serve –host 0.0.0.0 –force_polling

This will grab the github repo in to the docker container, checkout our branch that we want to test (the branch name is passed as a parameter into the ARM template as we’ll see below in the Powershell), update the _config.yml file (which is a config file Jekyll uses) to replace the public url with the URL for our Azure VM (so when we test the site, the links all point to the same testing site URL), use bundle to install all our gems, then fire up Jekyll to run our site.

Now that we have a JSON file that describes our Azure Resources, we need a way to deploy this.  This is a simple bit of PowerShell.  My goal here was to make this as simple as possible for somebody to use, even if they aren’t comfortable with PowerShell/Azure/Docker/Linux/Jekyll/etc.  It’s as simple as running the PS1, being prompted for 4 things (new resource group name, github branch name, azure login, azure subscription), then waiting ~10 mins for Azure to do it’s thing.

{% codeblock lang:powershell %}
$EnvName = Read-Host "Name for Azure Resource Group (must be globally unique)?"
$BranchName = Read-Host "Name of branch in git?"

Add-AzureAccount | Out-Null
$AllSubscriptions = Get-AzureSubscription

if ($AllSubscriptions.Count -eq 1)
{
    Select-AzureSubscription $AllSubscriptions[0].SubscriptionName
    Write-Host ("Only 1 Azure Subscription found. Using " + $AllSubscriptions[0].SubscriptionName)
}
else
{
    $AzureSub = $AllSubscriptions | Out-GridView -Title "Select Azure Subscription" -PassThru
    Select-AzureSubscription $AzureSub.SubscriptionName
}

Switch-AzureMode AzureResourceManager

$TemplateFile = Join-Path $PSScriptRoot "wddocker.json"
$params = @{branchName="$BranchName"}
New-AzureResourceGroup -Location "West US" -Name $EnvName -TemplateFile $TemplateFile -TemplateParameterObject $params -verbose

Write-Host "Your site will be available at this URL: http://$EnvName.westus.cloudapp.azure.com:4000"
Read-Host "Press enter to launch a browser to your new site - if it gives an error wait a minute then refresh"
Start-Process "http://$EnvName.westus.cloudapp.azure.com:4000"

Write-Host "When you're finished testing you should delete the Azure Resource Group"
Write-Host "You can do it yourself in portal.azure.com"
Write-Host "Or in PS using Remove-AzureResourceGroup -Name $EnvName"
Write-Host "Or this script can do it for you automatically (leave this open until done testing)"
Write-Host ""
$DeleteRG = Read-Host "Do you want to delete the Azure Resource Group $EnvName now (y/n)?"

if ($DeleteRG.ToUpper() -eq "Y")
{
    Remove-AzureResourceGroup -Name $EnvName -Force -Verbose
}

Read-Host "Press enter to close this window"
{% endcodeblock %}

The interesting line here is the one that does New-AzureResourceGroup.  That passes the JSON template to azure and tells it to create a new resource group and provision the resources described in the template.  We also tell it the azure datacenter location where everything should be created, and pass in a parameter that contains the branch name.

The rest of the script is just collecting some values from the user, and at the end it will launch your browser to the newly created site, and give you the option to delete all the azure resources just created if you wish.

## Try it for Yourself
You can easily give this a try yourself.

 1. [Download wddocker.json and deploy.ps1 from github](https://github.com/westerndevs/western-devs-website/tree/source/_azure)
 2. If you haven’t already you need to install azure powershell. You can get the installer in the [github folder](https://github.com/westerndevs/western-devs-website/tree/source/_azure), or [from Microsoft](https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/)
 3. Run deploy.ps1
 4. When prompted for branch name use: source
 5. ???
 6. Profit!!!

![ARM Deployment](http://www.westerndevs.com/images/Azure%20ARM%20Deploy.png)

## Complete ARM Template JSON

{% codeblock lang:json %}
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "branchName": {
      "type": "string",
	  "defaultValue": "source"
    }
  },
  "variables": {
	"newStorageAccountName": "[toLower(resourceGroup().name)]",
	"location": "[resourceGroup().location]",
	"adminUsername": "WesternDevs",
	"adminPassword": "P2ssw0rd",
	"dnsNameForPublicIP": "[toLower(resourceGroup().name)]",
    "imagePublisher": "Canonical",
    "imageOffer": "UbuntuServer",
    "ubuntuOSVersion": "15.04",
    "OSDiskName": "[resourceGroup().name]",
    "nsgName": "myNSG",
    "nicName": "myVMNic",
    "extensionName": "DockerExtension",
    "addressPrefix": "10.0.0.0/16",
    "subnetName": "Subnet",
    "subnetPrefix": "10.0.0.0/24",
    "storageAccountType": "Standard_LRS",
    "publicIPAddressName": "myPublicIP",
    "publicIPAddressType": "Dynamic",
    "vmStorageAccountContainerName": "vhds",
    "vmName": "[resourceGroup().name]",
    "vmSize": "Basic_A1",
    "virtualNetworkName": "MyVNET",
    "vnetID": "[resourceId('Microsoft.Network/virtualNetworks',variables('virtualNetworkName'))]",
    "nsgID": "[resourceId('Microsoft.Network/networkSecurityGroups',variables('nsgName'))]",
    "subnetRef": "[concat(variables('vnetID'),'/subnets/',variables('subnetName'))]"
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "name": "[variables('newStorageAccountName')]",
      "apiVersion": "2015-05-01-preview",
      "location": "[variables('location')]",
      "properties": {
        "accountType": "[variables('storageAccountType')]"
      }
    },
    {
      "apiVersion": "2015-05-01-preview",
      "type": "Microsoft.Network/publicIPAddresses",
      "name": "[variables('publicIPAddressName')]",
      "location": "[variables('location')]",
      "properties": {
        "publicIPAllocationMethod": "[variables('publicIPAddressType')]",
        "dnsSettings": {
          "domainNameLabel": "[variables('dnsNameForPublicIP')]"
        }
      }
    },
    {
      "apiVersion": "2015-05-01-preview",
      "type": "Microsoft.Network/virtualNetworks",
      "name": "[variables('virtualNetworkName')]",
      "location": "[variables('location')]",
      "dependsOn": [
        "[variables('nsgID')]"
      ],
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "[variables('addressPrefix')]"
          ]
        },
        "subnets": [
          {
            "name": "[variables('subnetName')]",
            "properties": {
              "addressPrefix": "[variables('subnetPrefix')]",
              "networkSecurityGroup": {
                "id": "[variables('nsgID')]"
              }
            }
          }
        ]
      }
    },
    {
      "apiVersion": "2015-05-01-preview",
      "type": "Microsoft.Network/networkInterfaces",
      "name": "[variables('nicName')]",
      "location": "[variables('location')]",
      "dependsOn": [
        "[concat('Microsoft.Network/publicIPAddresses/', variables('publicIPAddressName'))]",
        "[concat('Microsoft.Network/virtualNetworks/', variables('virtualNetworkName'))]"
      ],
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses',variables('publicIPAddressName'))]"
              },
              "subnet": {
                "id": "[variables('subnetRef')]"
              }
            }
          }
        ]
      }
    },
    {
      "apiVersion": "2015-05-01-preview",
      "type": "Microsoft.Network/networkSecurityGroups",
      "name": "[variables('nsgName')]",
      "location": "[variables('location')]",
      "properties": {
        "securityRules": [
          {
            "name": "http",
            "properties": {
              "description": "Allow HTTP",
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "destinationPortRange": "4000",
              "sourceAddressPrefix": "Internet",
              "destinationAddressPrefix": "*",
              "access": "Allow",
              "priority": 100,
              "direction": "Inbound"
            }
          },
          {
            "name": "ssh",
            "properties": {
              "description": "Allow SSH",
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "destinationPortRange": "22",
              "sourceAddressPrefix": "Internet",
              "destinationAddressPrefix": "*",
              "access": "Allow",
              "priority": 110,
              "direction": "Inbound"
            }
          }
        ]
      }
    },
    {
      "apiVersion": "2015-05-01-preview",
      "type": "Microsoft.Compute/virtualMachines",
      "name": "[variables('vmName')]",
      "location": "[variables('location')]",
      "dependsOn": [
        "[concat('Microsoft.Storage/storageAccounts/', variables('newStorageAccountName'))]",
        "[concat('Microsoft.Network/networkInterfaces/', variables('nicName'))]"
      ],
      "properties": {
        "hardwareProfile": {
          "vmSize": "[variables('vmSize')]"
        },
        "osProfile": {
          "computername": "[variables('vmName')]",
          "adminUsername": "[variables('adminUsername')]",
          "adminPassword": "[variables('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "[variables('imagePublisher')]",
            "offer": "[variables('imageOffer')]",
            "sku": "[variables('ubuntuOSVersion')]",
            "version": "latest"
          },
          "osDisk": {
            "name": "osdisk1",
            "vhd": {
              "uri": "[concat('http://',variables('newStorageAccountName'),'.blob.core.windows.net/',variables('vmStorageAccountContainerName'),'/',variables('OSDiskName'),'.vhd')]"
            },
            "caching": "ReadWrite",
            "createOption": "FromImage"
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces',variables('nicName'))]"
            }
          ]
        }
      }
    },
    {
      "type": "Microsoft.Compute/virtualMachines/extensions",
      "name": "[concat(variables('vmName'),'/', variables('extensionName'))]",
      "apiVersion": "2015-05-01-preview",
      "location": "[variables('location')]",
      "dependsOn": [
        "[concat('Microsoft.Compute/virtualMachines/', variables('vmName'))]"
      ],
      "properties": {
        "publisher": "Microsoft.Azure.Extensions",
        "type": "DockerExtension",
        "typeHandlerVersion": "1.0",
        "autoUpgradeMinorVersion": true,
		"settings": {
          "compose": {
            "wddocker": {
              "image": "abarylko/western-devs:v1",
              "ports": [
                "4000:4000"
              ],
			  "stdin_open": true,
			  "command": "[concat('bash -c \"git clone https://github.com/westerndevs/western-devs-website.git && cd western-devs-website && git checkout ', parameters('branchName'), ' && sed -i s/www.westerndevs.com/', variables('dnsNameForPublicIP'), '.westus.cloudapp.azure.com:4000/g _config.yml && bundle install && jekyll serve --host 0.0.0.0 --force_polling\"')]"
            }
          }
		}
      }
    }
  ]
}
{% endcodeblock %}