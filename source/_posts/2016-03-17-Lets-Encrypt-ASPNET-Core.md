---
title: Certificates for Everyone! Let's Encrypt in Azure with ASP.NET Core
layout: post
tags:
  - asp.net
  - let's encrypt
  - azure
categories:
  - Tools
authorId: dave_white
date: 2016-03-22 16:00:00 
excerpt: "This may have been one of the most exciting things (from a web site owner's perspective) to happen in quite a while..."
---

This may have been one of the most exciting things (from a web site owner's perspective) to happen in quite a while, and something I think the industry
has been hoping would happen for a long time. Free SSL certificates for everyone! With the creation of [letsencrypt.org][1], an organization whose goal is to 
make certificate usage free and easy, we are finally freed from the shackles of organizations like GoDaddy or Verisign who charge (sometimes exorbitant) fees
just so that an individual or organization can have the ability encrypt their web traffic.

<!-- more -->

Now the tricky thing with Let's Encrypt is the automation part. Because of how Let's Encrypt uses automation to provision certificates, it was originally built to
work with Apache/Linux based web servers. This made anyone who used Azure or IIS feel like the kid on the outside looking in. Luckily, nothing that Let's Encrypt
does is voodoo magic and it didn't take long for the Azure community to build the necessary parts to get this working in Azure.

There is a fantastic post from [Nik Molnar][2] that describes
how to get this working on Azure. I definitely want to talk about Let's Encrypt on Azure, but I don't want to take away from Nik's post, so go there and  check it out.

What I'm going to add though is a bit of PowerShell goodness around some of his steps that makes it a bit easier to get Let's Encrypt up and running on your Azure
website. I'm also going to add a couple tidbits about getting it working on ASP.NET Core.

#### Pre-requisites

Just going to re-iterate [Nik's prerequisites][2]:
1. Scale up your Azure Website to at least an S1 (1 dedicated IP, 5 SNI)
2. Acquire your custom domain. The _{domain name here}_.azurewebsites.net domains are all secured with by a Microsoft certificate so if you aren't planning on using your own domain name, you can just stop now.
3. Create a storage account for the Let's Encrypt Site extension to use
4. Put your storage account conne   ction strings into two Application Settings on your website.
5. Register a Service Princpal. This is the identity that is allowed to execute the web jobs the the site extension uses to do the work 

## PowerShell

Again, as per [Nik's post][2], you'll need the [Azure PowerShell module][3] before we get started. 

In an Azure .ps1 (script) or .psm1 (module), or in PowerShell ISE, paste the function below. 

{% codeblock lang:powershell %}
function Set-AllAzureDetailsForLetsEncrypt() {
<# 
    .SYNOPSIS
    Set up an Azure Website to be able to use the Let's Encrypt Site Extension
    .DESCRIPTION
    This function will use the information provided to create a new connection between the Let's Encrypt Site extension and your website.
    It will then use this user/connection to setup the certificate from Let's Encrypt on your web site
    .EXAMPLE
    Set-AllAzureDetailsForLetsEncrypt -subscriptionId {guid} -uniqueUri {Any unique Url} -strongPassword {password} -displayName {Name of Application} -resourceGroupName {Name of ResourceGroup to work in}
    .EXAMPLE
    Set-AllAzureDetailsForLetsEncrypt -subscriptionId 00000000-0000-0000-0000-000000000000 -uniqueUri "http://myapplication-091820398123" -strongPassword "P@ssw0rd" -displayName "Let's Encrypt Site Extension" -resourceGroupName "Default-Web-WestUS"
    .PARAMETER subscriptionId
    (optional) The subscriptionId to attempt to use during the login
    .PARAMETER uniqueUri
    The uniqueUri of the "app" that we are creating in Azure Active Directory 
    .PARAMETER strongPassword
    The strong password of the "app" that we are creating in Azure Active Directory 
    .PARAMETER displayName
    (optional) The name of the application that we will be creating in Azure Active Directory (defaults to "Let's Encrypt Site Extension")
    .PARAMETER resourceGroupName
    The name of the ResourceGroup that this app lives in.
#>

    [CmdLetBinding()]
    param(
        [parameter(Mandatory = $false)]
        [guid]$subscriptionId,
        [parameter(Mandatory = $true)]
        [string]$uniqueUri,
        [parameter(Mandatory = $true)]
        [string]$strongPassword,
        [parameter(Mandatory = $false)]
        [string]$displayName,
        [parameter(Mandatory = $true)]
        [string]$resourceGroupName
    )
    begin{
        if([string]::IsNullOrEmpty($displayName)){ $displayName = "Let's Encrypt Site Extension" }
    }
    process{
         # log into your Azure Account for a given subscription
         try{
            if($subscriptionId -eq $null){
                $account = Login-AzureRMAccount
            } else {
                $account = Login-AzureRMAccount -SubscriptionId $subscriptionId
            }
         }catch{
            Write-Error "Failed to log into Azure with the credentials or SubscriptionId provided."
            break             
         }
         
         # create a new active directory application
         $app = New-AzureRmADApplication -DisplayName $displayName -HomePage $uniqueUri -IdentifierUris $uniqueUri -Password $strongPassword
         
         # create a new Service Principal for your application
         New-AzureRmADServicePrincipal -ApplicationId $app.ApplicationId
         
         # assign your Service princpal as a contributor
         New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $app.ApplicationId
         
         # store these details to transfer to the extension which will use the service principal to do it's work
         $letsEncrypt = @{}
         $letsEncrypt.Tenant = $account.Context.Tenant.TenantId
         $letsEncrypt.SubscriptionId = $account.Context.Subscription.SubscriptionId
         $letsEncrypt.ClientId = $app.ApplicationId 
         $letsEncrypt.ClientSecret = $strongPassword
         $letsEncrypt.ResourceGroupName = $resourceGroupName
         
         # return the letsEncrypt object with all of our details to make it easy to clip them into the website extensions fields 
         $letsEncrypt
    }
    end{}
} #end function Set-AllAzureDetailsForLetsEncrypt
{% endcodeblock %}

After you've pasted this function into a PowerShell script file or directly into a session type in the following:
{% codeblock lang:powershell %}
$letsEncrypt = Set-AllAzureDetailsForLetsEncrypt -subscriptionId <Insert SubscriptionId Here> -uniqueUri "http://myapplication-091820398123" -strongPassword "P@ssw0rd" -displayName "Let's Encrypt Site Extension" -resourceGroupName "Default-Web-WestUS"
{% endcodeblock %}

You do not need to provide the SubscriptionId if your account/login is only associated with one subscription. Also, you do not need to provide a DisplayName if you don't mind the display name being "Let's Encrypt Site Extension". You must provide the other parameters.

Once you have run through the script, you should have an object in the `$letsEncrypt` variable that has everything you need for entering the data in the Site Extension.
```
$letsEncrypt 

Name                           Value                                                            
----                           -----                                                            
SubscriptionId                 841de3ae-429e-481c-9553-c4542abdd228                             
ResourceGroupName              Default-WestUs-1                                                 
Tenant                         ff778d23-bb9d-431d-9ea1-b63f31ae5244                             
ClientSecret                   P@ssw0rd                                                         
ClientId                       00000000-0000-0000-0000-000000000000                                                                
```

Now you will be able to type `$letsEncrypt.Tenant | clip` to get the TenantId for pasting into the Site Extension fields. You can do this for each
field that is required for the extension to run.

## ASP.NET Core
ASP.NET Core (formerly know as ASP.NET 5/MVC 6) had a different approach to handling static files, which are required for Let's Encrypt to work. Basically, 
what happens is the WebJob gets some files from Let's Encrypt. Let's Encrypt will then use the DNS entry and this "well-known" location on your site to see if the files
are there. If they are there, you own the domain, and the certificate can be approved automatically. If you didn't own the domain, and hadn't setup the Let's Encrypt Site Extension
to do all of this work, none of this would have worked and it could be assumed that you do not own the domain.

If you look in your Kudo dashboard after the Let's Encrypt Site Extension has run, you'll see the following you your folder structure:

d:/home/site/wwwroot/.well-known/acme-challenge

And you'll see the challenge files in the last folder

![.well-known-acme-challenge](http://i.imgur.com/sQcRNFX.png)

#### The Thing I had Trouble With
I couldn't find a good example at the time of how to allow Let's Encrypt to get these .well-known files using ASP.NET Core. So I created a controller that basically returned the contents when asked for a specific route.

The URI that Let's Encrypt will look for these well-known files is http://{mydomainname}.com/.well-known/acme-challenge 

{% codeblock lang:csharp %}
[Route(".well-known")]
public class WellKnownController : Controller
{
    public WellKnownController(IHostingEnvironment env)
    {
        Env = env;
    }

    private IHostingEnvironment Env { get; }

    [HttpGet("acme-challenge/{id}")]
    [Produces("text/json")]
    public IActionResult Get(string id)
    {
        var content = string.Empty;
        var path = Env.WebRootPath;
        var fullPath = Path.Combine(path, @".well-known\acme-challenge");
        var dirInfo = new DirectoryInfo(fullPath);
        var files = dirInfo.GetFiles();
        foreach (var fileInfo in files)
        {
            if (fileInfo.Name == id)
            {
                using (var file = System.IO.File.OpenText(fileInfo.FullName))
                {
                    return Ok(file.ReadToEnd());
                }
            }
        }
        return Ok(content);
    }
}
{% endcodeblock %}

#### Update
At the time of this writing, I haven't had a chance to confirm if this works since the Let's Encrypt files do not have an extension.
[Handling Static Files in ASP.NET Core][4]

## That's It!
Hopefully, between [Nik's fantastic post][2] and this post, you should have a fairly good understanding of what has been happening, and you've got your 
ASP.NET Core site secured and up and running on Azure using [Let's Encrypt][1]!!! 

[1]: https://letsencrypt.org
[2]: https://gooroo.io/GoorooTHINK/Article/16420/Lets-Encrypt-Azure-Web-Apps-the-Free-and-Easy-Way/20047#.Vuron4-cGM9
[3]: https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/
[4]: http://docs.asp.net/en/latest/fundamentals/static-files.html
