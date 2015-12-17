---
layout: post
title: "Configuring Features for Many TeamProjects in TFS 2015"
date: 2015-09-03 1:30:00
authorId: dave_white
originalurl: 
comments: true
alias: /configuring-features-for-many-teamprojects-in-tfs-2015/
---
One of the problems that comes with having multiple Team Project Collections and multiple Team Projects (in TFS) is the administrative burden required to upgrade or manage all of these projects. 
Security permissions, WIT modifications, configuration are all a 0..n problem so the more Team Projects you have, the more work it is, out of the box, to manage your TFS implementation.

There are numerous people and projects who have stepped up to help reduce this burden with applications, PowerShell scripts, and techniques for getting more work done with less effort.

One of those projects is [Features4tfs][1], a command line application project that builds on a couple blog posts to make feature configuration easier when dealing with multiple TeamProjects.

Unfortunately, I've discovered that something happened between TFS 2015 RC and TFS 2015 RTM and this project no longer works. I've updated the code to use the latest RTM Object model binaries
but I've just been unable to get it working. A few other people have run into this problem as well, and we've been unable to get any help or answers about this problem.

Regardless of getting help or not, I need to keep my client's migration/upgrade project moving forward and to that end, [PowerShell, IE Automation][2] and [my recent work with the TFS 2015 Object Model in PowerShell][3] to the rescue!

### Implementing the Automate-IEConfigureFeatures Script

In order to understand this script, you'll need to make sure you understand what I'm doing with [IE Automation][2] and using a [TFS PowerShell Module][3] that I've discussed previously on this [(and my)][4] blog. I'll be using techniques from both those posts.

First, we need to enhance my TFS PowerShell module to add a cmdlet that it didn't have from the previous post.
#### Implement Get-TfsTeamProjects CmdLet
{% codeblock lang:powershell %}
function Get-TfsTeamProjects() {
<# 
    .SYNOPSIS
    Get a collection of Team Projects from a Team Project Collection
    .DESCRIPTION
    Get a collection of Team Projects from a Team Project Collection (TPC) using the Id (guid) from the TPC object
    .EXAMPLE
    Get-TfsTeamProjects $configServer "000000-0000-000000-000000000" <--- GUID
    .EXAMPLE
    Get-TfsTeamProjects $cs <tpcID Here>
    .PARAMETER configServer
    The TfsConfigurationServer object that represents a connection to TFS server that you'd like to access
    .PARAMETER teamProjectCollectionId
    The id (guid) of the TeamProjectCollection that you'd like to get a list of TeamProjects from
#>

    [CmdLetBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Microsoft.TeamFoundation.Client.TfsConfigurationServer]$configServer, 
        [parameter(Mandatory = $true)]
        [guid]$teamProjectCollectionId

    )
    begin{}
    process{
         $tpc = $configServer.GetTeamProjectCollection($teamProjectCollectionId)
         #Get WorkItemStore
         $wiService = $tpc.GetService([Microsoft.TeamFoundation.WorkItemTracking.Client.WorkItemStore])
         #Get a list of TeamProjects
         $wiService.Projects
    }
    end{}
} #end function Get-TfsTeamProjects 
{% endcodeblock %}

In this CmdLet, we build on our understanding of the TFS Object Model and, using the WorkItemStore, get a list of all TeamProject in a TPC and return that list from the cmdlet.

#### Composing our IE Automation Script

Luckily, the Feature Configuration page is simple, easily addressable, and behaves consistently so it is actually very easy to automate.

Now we're going to Import-Module (ipmo alias in PowerShell) my TFS PowerShell module. We'll use that functionality for connecting to TFS and getting the lists of TeamProjectCollections and TeamProjects. 
This Script is not going to be a cmdlet, so it isn't going to be as pretty (or well documented, or perhaps efficient) as the TFS module we've been using.

There is a function in this Script to help with quickly finding buttons that we're expecting on the TFS Web Access Admin page we're working on.

{% codeblock lang:powershell %}
cls

ipmo <TfsPowerShellModuleNameHere>

function Find-Button($ieDoc, $btnText){
    $btns = $ieDoc.getElementsByTagName("button")
    foreach($innerBtn in $btns) 
    {
        if($innerBtn.parentElement.className -ne "ui-dialog-buttonset") {continue}
        $innerSpans = $innerBtn.getElementsByTagName("span")
        foreach($span in $innerSpans)
        {
            if (($span.InnerText) -and ($span.InnerText.Contains($btnText))) {
                #find the button that has a span that has the text btnText
                $span.parentElement
                break;
            }
        }
    }
}

$ie = new-object -ComObject "InternetExplorer.Application"

$cs = Get-TfsConfigServer <TFS AppTier URL here>
$tpcIds = Get-TfsTeamProjectCollectionIds $cs

foreach ($tpcId in $tpcIds){
    
    $tpc = Get-TfsTeamProjectCollection $cs -teamProjectCollectionId $tpcId
    [string]$tpcUri =  $tpc.Uri.AbsoluteUri

    $projects = Get-TfsTeamProjects -configServer $cs -teamProjectCollectionId $tpcId
    foreach ($proj in $projects){
        [string]$projectName = $proj.Name
        $requestUri = [string]::Format("{0}/{1}/_admin#_a=enableFeatures", $tpcUri, $projectName.Replace(" ", "%20"))
        $verifyButtonText = "Verify"
        $configureButtonText = "Configure"
        $closeButtonText = "Close"

        $ie.visible = $true
        $ie.silent = $true
        $ie.navigate($requestUri)
        while($ie.Busy) { Start-Sleep -Milliseconds 100 }

        $doc = $ie.Document
        
        #discover Verification button 
        $btn = Find-Button $doc $verifyButtonText

        if ($btn -eq $null) { continue }
    
        #start Verification
        $btn.click()

        Start-Sleep -Milliseconds 1000

        $buttonNotFound = $true
        #wait for verification to complete
        while ($buttonNotFound) {
            $closeBtn = $null;$configBtn = $null;
            $closeBtn = Find-Button $doc $closeButtonText
            $configBtn = Find-Button $doc $configureButtonText
            if (($closeBtn -ne $null) -or ($configBtn -ne $null)){
                $buttonNotFound = $false;
            }else {
                Start-Sleep -Milliseconds 1000
            }
        }

        if ($closeBtn -ne $null) {
            Write-Host "Cannot configure features for TeamProject " -NoNewline
            Write-host "($($proj.Name)). " -NoNewLine -ForegroundColor Yellow
            Write-Host "It needs to be upgraded first."
            $warningText = $doc.getElementById("issues-textarea-id").InnerText
            Write-Host $warningText -ForegroundColor Red | fl -Force
            $closeBtn.click()
        }
        elseif ($configBtn -ne $null) {
            #start Configuration
            $configBtn.click()

            #wait for configuration to complete
            Start-Sleep -Milliseconds 500

            #close Configuration
            $buttonNotFound = $true
            while ($buttonNotFound) {
                $closeBtn = $null;
                $closeBtn = Find-Button $doc $closeButtonText
                if ($closeBtn -ne $null){
                    $buttonNotFound = $false;
                }else {
                    Start-Sleep -Milliseconds 500
                }
            }

            $closeBtn.click()
            
        }
        else{
            Write-Host "Failed to find a button"
        }
    }
}

{% endcodeblock %}

### Final Thoughts
So that is it. I hope that the script is self-explanatory enough for you. I hope that you take away from this blog that there are usually many ways to solve 
a problem and sometimes we just have to roll up our sleeves and get our hands dirty and do our work in a functional and non-elegant manner. 
Don't let minor technical glitches get in the way of getting your work done.

There are the side benefits to this that you don't need to understand how the Feature Configuration works at a code level. You just need to be able to get 
your automation to click buttons.  


[1]: https://features4tfs.codeplex.com
[2]: http://www.westerndevs.com/simple-powershell-automation-browser-based-tasks/
[3]: http://www.westerndevs.com/tfs-module-in-powershell-using-nuget/
[4]: http://www.agileramblings.com
