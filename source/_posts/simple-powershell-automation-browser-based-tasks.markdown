---
layout: post
title:  Using IE Automation in PowerShell to Simplify Browser Based Tasks
date: 2015-07-24T17:30:00-06:00
categories:
comments: true
authorId: dave_white
originalurl: http://agileramblings.com/2015/07/22/using-ie-automation-in-powershell-to-simplify-tasks/
alias: /simple-powershell-automation-browser-based-tasks/
---

As a consultant, one of the things that I need to do regularly is log into my client's WiFi networks. Sometimes this is a once per month task, sometimes it is a daily task. It was a daily version of this task that made me look into doing this a bit quicker. Opening Internet Explorer (or any browser) and then navigating to the page, typing in all of my credentials, and then submitting the request is a fairly monotonous task, and it isn't very quick.

<!--more-->

Now a days, I almost always have a PowerShell window open, and because of another little experiment I did with PowerShell and IE, I thought it should be easy to automate my WiFi network login. So I that is what I set out to do.

The way that I'm currently working in PowerShell is to create a .ps1 file to do my development in. That way I can version control the file, and keep it separate from other things that are working or in progress. So in this case, I made a PowerShell script file called Login-GuestWifi.ps1. In this file, I just started typing lines of PowerShell script and eventually I would move it into a CmdLet or a function somewhere else.

The first line in the PowerShell script is a call to create an Internet Explorer Application.
{% codeblock lang:powershell %}
$ie = new-object -ComObject "InternetExplorer.Application"
{% endcodeblock %}

Now that you've got IE in your PowerShell code, you need to figure out what to do with this. This is going to require a little bit of work in the browser so you're going to have to open a browser and navigate to the page you're going to be working with. In my case, this was an internal IP address that I was re-directed to when using the browser for the first time on the guest WiFi network.

http://10.10.10.10 – Example URL

![image][1]

Once I've navigated there, I press F12 to get to the developer tools of my browser. (I'll use IE for my examples)

![image][2]

Using the Dev Tools, I'm going to discover what the fields I need to fill in are (their id or class). In this case, I found fragments of ids that were not generated. I took those fragments and put them into my PowerShell code along with URL of the login page.
{% codeblock lang:powershell %}
$requestUri = http://10.10.10.10/guest/wifi-guest.php
$userIdFragment = "weblogin_user";
$passwordIdFragment = "weblogin_password";
$acceptTermsInputFragment = "weblogin_visitor_accept_terms"
$buttonIdFragment = "weblogin_submit";
{% endcodeblock %}

I now have details of where to go and ability to find the elements on the page that I'm interested in. I'm going to now invoke some methods on the IE Application instance I have to navigate to the Url.
{% codeblock lang:powershell %}
#$ie.visible = $true
$ie.silent = $true
$ie.navigate($requestUri)
while($ie.Busy) { Start-Sleep -Milliseconds 100 }
{% endcodeblock %}

The first two lines indicate how IE is supposed to behave in two ways and the first one is commented out.

1. Show the instance of IE. With this line commented out, we get a "headless" browsing experience with no visible window or rendering.  [Visible Property - MSDN][3]
2. Do not show any dialogs that may pop up. [Silent Property - MSDN][5]

The next instruction tells IE to navigate to the Url provided.

The 4th line of this script fragment is interesting. We need to wait for IE to actually do the navigation. If we don't add this line, the PowerShell script will happily continue executing much faster than IE will retrieve and load the page into the Document Object Model (DOM) and the rest of your script will probably fail.

After IE has loaded up the DOM, we can now find our elements, give them values, and click the Submit button.

{% codeblock lang:powershell %}
$doc = $ie.Document
$doc.getElementsByTagName("input") | % {
    if ($_.id -ne $null){
        if ($_.id.Contains($buttonIdFragment)) { $btn = $_ }
        if ($_.id.Contains($acceptTermsInputFragment)) { $at = $_ }
        if ($_.id.Contains($passwordIdFragment)) { $pwd = $_ }
        if ($_.id.Contains($userIdFragment)) { $user = $_ }
    }
}

$user.value = "<user name="" here="">"
$pwd.value = "<password here="">"
$at.checked = "checked"
$btn.disabled = $false
$btn.click()
Write-Verbose "Login Complete"
{% endcodeblock %}

One interesting thing about IE automation is that any JavaScript or page behaviours that we would expect to execute don't seem to run, so we need to explicitly enable the submit button in the event that it was not enabled until all of the fields were entered and the accept terms of use checkbox was clicked.

And that's it! I now have a PowerShell script that runs in seconds and logs me into the client's guest WiFi network.

![image][4]

As a final task, I took the code in my Login-GuestWifi.ps1, converted it to a function and placed it in my ./profile.ps1 file that gets invoked any time a PowerShell session is started on my machine.

It should be noted that the UserName and Password, in my case, were not secured in any fashion other than being only physically stored on my machine in my scripts file. I never checked my credentials into source control and I had no need to put them anywhere else. If needed, I could secure them but that wasn't necessary. These are not domain credentials and are only giving people access to the guest WiFi network.

### Final Thoughts

My goal with this post was to exposed you to the idea of using PowerShell to automate simple web-based tasks in Internet Explorer. I've recently been using PowerShell a lot and I've just been continuously impressed with how powerful it is. So go give it a try!

[1]: http://agileramblings.files.wordpress.com/2015/07/image_thumb.png?w=244&amp;h=186 "image"
[2]: http://agileramblings.files.wordpress.com/2015/07/image_thumb1.png?w=244&amp;h=219 "image"
[3]: https://msdn.microsoft.com/en-us/library/aa752082%28v=vs.85%29.aspx "https://msdn.microsoft.com/en-us/library/aa752082%28v=vs.85%29.aspx"
[4]: http://agileramblings.files.wordpress.com/2015/07/image_thumb2.png?w=244&amp;h=80 "image"
[5]: https://msdn.microsoft.com/en-us/library/aa752074(v=vs.85).aspx "https://msdn.microsoft.com/en-us/library/aa752074(v=vs.85).aspx"