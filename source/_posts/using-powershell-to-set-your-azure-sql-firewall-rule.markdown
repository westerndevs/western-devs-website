---
layout: post
title:  Using PowerShell to Set Your Azure SQL firewall rule
date: 2015-07-26T17:30:00-06:00
categories:
comments: true
authorId: dave_white
originalurl: http://agileramblings.com/2015/07/26/using-powershell-to-set-your-azure-sql-firewall-rule/
---

If you've read a couple of my recent blog posts, you'll see that I've been working in PowerShell a lot lately. I've also been working with Azure a lot lately as well and I'm getting opportunities to put those two things together.

Since my laptop is moving around a lot and occasionally my home IP address changes, I do need to update my Azure SQL Firewall rule to allow my computer at my current my IP address to talk to my Azure SQL database server. 

[Azure SQL Database Firewall][1]

I've added 4 simple functions to my .\profile.ps1 script that makes this job really easy.

{% codeblock lang:powershell %}
function Set-MyAzureFirewallRule {
    $response = Invoke-WebRequest ifconfig.me/ip
    $ip = $response.Content.Trim()
	New-AzureSqlDatabaseServerFirewallRule -StartIPAddress $ip -EndIPAddress $ip -RuleName <Name of Rule> -ServerName <your database server name here>
}
function Update-MyAzureFirewallRule{
    $response = Invoke-WebRequest ifconfig.me/ip
    $ip = $response.Content.Trim()
    Set-AzureSqlDatabaseServerFirewallRule -StartIPAddress $ip -EndIPAddress $ip -RuleName <Name of Rule> -ServerName <your database server name here>
}
function Remove-MyAzureFirewallRule{
    Remove-AzureSqlDatabaseServerFirewallRule -RuleName <Name of Rule> -ServerName <your database server name here>
}
function Get-MyAzureFirewallRule{
    Get-AzureSqlDatabaseServerFirewallRule -RuleName <Name of Rule> -ServerName <your database server name here>
}
{% endcodeblock %}

### Get the Azure PowerShell Module
The first thing you'll need to do if you want to do any work with Azure via PowerShell is download and install the Azure PowerShell modules. 

[Install And Configure Azure PowerShell][2]

Once you've done this, you'll be able to run Azure CommandLets in your PowerShell session.

### How to get your IP address

Since many times I'm behind a router that is doing NAT translations, knowing my IP address isn't as simple as typing `Get-NetIPAddress | Format-Table` or `ipconfig` in a console. That will tell me what my computer thinks the IP address is in my local network, but that isn't what Azure will see. Azure will see the IP address of my cable modem.

In order to find out what my IP address is from an external perspective, I need the help of a little service called <a href="http://ifconfig.me/" target="_blank">ifconfig.me</a> to tell me what my IP address is externally. If you make the whole Url <a href="http://ifconfig.me/ip" target="_blank">ifconfig.me/ip</a> you will get a simple text response from them with your IP address. Just give that Url a click and try it out. If you view the page source, you'll see that only text was returned.

### Putting it all together

 So now we have the Azure PowerShell modules and we know about ifconfig.me. All we need now is the put the two together into one of our functions. I'll use my first function as the example. You'll be able to follow the rest after I describe this one. 
 
{% codeblock lang:powershell %}
function Set-MyAzureFirewallRule {
    $response = Invoke-WebRequest ifconfig.me/ip
    $ip = $response.Content.Trim()
	New-AzureSqlDatabaseServerFirewallRule -StartIPAddress $ip -EndIPAddress $ip -RuleName <Name of Rule> -ServerName <your database server name here>
}
{% endcodeblock %}

The first line is the PowerShell (non-Azure) CmdLet `Invoke-WebRequest ifconfig.me/ip`. This will call ifconfig.me/ip and get a response, trapped in the `$response` variable. 

In the next line, I clean up the response a little bit using some .Net string functions to move my IP address into the `$ip` variable.

Finally, I call the Azure PowerShell CmdLet to create a new Firewall rule in my Azure account.

> You will have to have followed the instructions in [Azure PowerShell Install and Configure][2] to set up the authentication to allow this PowerShell session to access your Azure subscription.

The other three variations of this function are for completeness. You will actually probably use the `Update-MyAzureFirewallRule` most since you'll set-up the Firewall rule once the first time and then you'll just need to update it whenever your IP address changes.

### Final Thoughts

I hope this post makes it easier for you to access your SQL Azure database server from your laptop, where ever it may have moved. Once you've set up the rule, you'll be able to access your database server from the tools in Visual Studio, SQL Server Management Studio, or any other tool you prefer to use to work with your Azure SQL Server. 

Enjoy!! 

[1]: https://msdn.microsoft.com/en-us/library/azure/ee621782.aspx "https://msdn.microsoft.com/en-us/library/azure/ee621782.aspx"
[2]: https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/ "https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/"
