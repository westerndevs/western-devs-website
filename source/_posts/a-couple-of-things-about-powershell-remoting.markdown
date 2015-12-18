---
layout: post
title:  A Couple of Things About Powershell Remoting
date: 2015-09-03T08:18:46-06:00
categories:
comments: true
authorId: simon_timms
alias: /a-couple-of-things-about-powershell-remoting/
---

I couldn't find the answers to these questions readily anywhere on the internet so I thought I would write them down here for the good of mankind.

**When using remoting as a different user does the target account or my account need to be an admin?**

<!--more-->

The target account is the key one here. If you're logging in with a different user account you don't need to have any sort of admin rights yourself but the account specifed in the credentials you pass in will.

**Do you really need to be an administrator to use remoting?**

No. You either need to be an admin or in the "Remote Management Users" group. 

**Is remoting pretty much just SSH?**

More or less. The usual way of using remoting is to use the ```Invoke-Command``` commandlet which just executes a single command. However there is another one called ```Enter-PSSession``` and this one lets you enter an interactive mode.

{% codeblock lang:powershell %}
    Invoke-command remotemachinename -Credential $cred -scriptblock { 
	somecommand.exe --some-parameters 
}
{% endcodeblock %}

vs

{% codeblock lang:powershell %}
    Enter-PSSession -computername remotemachinename -authentication credssp -Credential $cred 
{% endcodeblock %}