---
layout: post
title:  Setting Up an IIS Site Using PowerShell
date: 2015-08-12T11:29:25-06:00
categories:
comments: true
authorId: simon_timms
originalurl: http://blog.simontimms.com/2015/08/12/setting-up-an-iis-site-using-powershell/
alias: /setting-up-an-iis-site-using-powershell/
---

The cloud has been such an omnipresent force in my development life that I'd kind of forgotten that IIS even existed. There are, however, some companies that either aren't ready for the cloud or have legitimate legal limitations that make using the cloud difficult.

<!--more-->

This doesn't mean that we should abandon some of the niceties of deploying to the cloud such as being able to promote easily between environments. As part of being able to deploy automatically to new environments I wanted to be able to move to a machine that had nothing but IIS installed and run a script to do the deployment.

I was originally thinking about looking into PowerShell Desired State Configuration but noted brain-box [Dylan Smith](http://www.westerndevs.com/bios/dylan_smith/) told me not to bother. He feeling was that it was a great idea whose time had come but the technology wasn't there yet. Instead he suggested just using PowerShell proper.

Well okay. I had no idea how to do that.

So I started digging. I found that PowerShell is really pretty good at setting up IIS. It isn't super well documented, however. The PowerShell documentation is crummy in comparison with stuff in the .net framework. I did hear on an episode of Dot Net Rocks that the UI for IIS calls out to PowerShell for everything now. So it must be possible.

The first step is to load in the powershell module for IIS

{% codeblock lang:powershell %}
Import-Module WebAdministration
{% endcodeblock %}

That gives us access to all sorts of cool IIS stuff. You can get information on the current configuration by cding into the IIS namespace.

{% codeblock lang:powershell %}
C:\WINDOWS\system32> cd IIS:
IIS:\> ls

Name
----
AppPools
Sites
SslBindings
{% endcodeblock %}

Well that's pretty darn cool. From here you can poke about and look at the AppPools and sites. I was told that by fellow Western Dev [Don Belcham](http://www.westerndevs.com/bios/donald_belcham/) that I should have one AppPool for each application so the first step is to create a new AppPool. I want to be able to deploy over my existing deploys so I have to turff it first.

{% codeblock lang:powershell %}
if(Test-Path IIS:\AppPools\CoolWebSite)
{
	echo "App pool exists - removing"
	Remove-WebAppPool CoolWebSite
	gci IIS:\AppPools
}
$pool = New-Item IIS:\AppPools\CoolWebSite
{% endcodeblock %}

This particular site needs to run as a particular user instead of the AppPoolUser or LocalSystem or anything like that. These will be passed in as a variable. We need to set the identity type to the confusing value of 3. This maps to using a specific user. The documentation on this is [near impossible to find](https://msdn.microsoft.com/en-us/library/ms689446(v=vs.90).aspx).

{% codeblock lang:powershell %}
$pool.processModel.identityType = 3
$pool.processModel.userName = $deployUserName
$pool.processModel.password = $deployUserPassword
$pool | set-item
{% endcodeblock %}

Opa! We have an app pool. Next up a website. We'll follow the same model of deleting and adding. Really this delete block should be executed before adding the AppPool.

{% codeblock lang:powershell %}
if(Test-Path IIS:\Sites\CoolWebSite)
{
echo "Website exists - removing"

Remove-WebSite CoolWebSite
gci IIS:\Sites
}
echo "Creating new website"
New-Website -name "CoolWebSite" -PhysicalPath $deploy_dir -ApplicationPool "CoolWebSite" -HostHeader $deployUrl
{% endcodeblock %}

The final step for this site is to change the authentication to turn off anonymous and turn on windows authentication. This requires using a setter to set individual properties.

{% codeblock lang:powershell %}
Set-WebConfigurationProperty -filter /system.webServer/security/authentication/windowsAuthentication -name enabled -value true -PSPath IIS:\Sites\CoolWebSite
Set-WebConfigurationProperty -filter /system.webServer/security/authentication/anonymousAuthentication -name enabled -value false -PSPath IIS:\Sites\CoolWebSite
{% endcodeblock %}

I'm not completely sure but I would bet that most other properties can also be set via these properties.

Well that's all pretty cool. I think will still investigate PowerShell DSC because I really like the idea of specifying the state I want IIS to be in and have something else figure out how to get there. This is especially true for finicky things like setting authentication.
