---
layout: post
title:  Building a TFS 2015 PowerShell Module using Nuget
date: 2015-07-23T17:30:00-06:00
categories:
comments: true
authorId: dave_white
originalurl: http://agileramblings.com/2015/07/23/building-a-tfs-2015-powershell-module-using-nuget/
---


*Update:* Unwittingly, I hadn’t tested my Nuget approach on a server with no Visual Studio or TFS installations on it and I’ve missed a couple assemblies that are required when loading the TFS Object model. I’ve updated the line of code in my samples, but just in case, here is the new version of the line in question.

<!--more-->

{% codeblock lang:powershell %}
$net45Dlls = $allDlls | ? {$_.PSPath.Contains("portable") -ne $true } | ? {$_.PSPath.Contains("resources") -ne $true } | ? { ($_.PSPath.Contains("net45") -eq $true) -or ($_.PSPath.Contains("native") -eq $true) -or ($_.PSPath.Contains("Microsoft.ServiceBus") -eq $true) }
{% endcodeblock %}

The update is the addition of two *-or* statements to the last inclusive where clause.

I’ve also slightly changed the *Import-TfsAssemblies* function to include a try/catch block for better error reporting.

#### Original Start

With the release of [Visual Studio 2015][1] on July 20, 2015,&nbsp;we can talk about and explore a lot of really cool things that are happening with Visual Studio (VS) and Team Foundation Server (TFS). One of the things that has been a bit of a pain when managing a TFS&nbsp;on-premises installation has been the necessity of installing Visual Studio to get the TFS client object model on your administrative workstation. With the explosive use of PowerShell to manage all things Microsoft, this has been a bit of&nbsp;a drag on using PowerShell for TFS work. There are PowerShell modules for TFS in the TFS Power Tools, but sometimes you need the power that comes with using the TFS Object Model. Which meant that you had to install Visual Studio. I'm really glad to say that is no longer the case. With the release of TFS 2015, the TFS Object Model is now available on [Nuget][2]! With our trusty nuget.exe, we can now get the TFS object model from a trusted source, without violating any license terms, to use in our own TFS PowerShell modules.

I'm not going to profess to be a PowerShell wizard so I hope I'm not breaking any community best practices too badly. I'm more than happy to adapt my implementation if I get feedback on better ways of doing things! It should also be noted that I'm using PowerShell 4. This is located in the Windows Managment Framework 4 download (http://www.microsoft.com/en-ca/download/details.aspx?id=40855), a free download from Microsoft. I don't **_think&nbsp;_**you'll have any problems upgrading from previous versions of PowerShell but I'm not going to any assurances.

Let's start walking through building a TFS PowerShell module!

## Create A PowerShell Module

I'm not going to go into a lot of details, but the basic steps to creating your PowerShell module are:

1. Navigate to %USERPROFILE%\My Documents\WindowsPowerShell\Modules
2. Create a folder called MyTfsModule
3. In the MyTfsFolder, create a file called MyTfsModule.psm1

It is important that the name of the Module folder and the Module file are the same. Otherwise, you won't be able to load your module. This one requirement&nbsp;tripped me up for a while when I started writing PowerShell modules.

## Module-Specific Variables And Helper Functions

There are a few module specific variables that we need to set when the module loads and a Helper function that I use for getting/creating folders. You can put these at the top of your MyTfsModule.psm1 file.
{% codeblock lang:powershell %}
Write-Host "Loading MyTfsModule"
#Module location folder
$ModuleRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
#where to put TFS Client OM files
$omBinFolder = $("$ModuleRootTFSOMbin")

# TFS Object Model Assembly Names
$vsCommon = "Microsoft.VisualStudio.Services.Common"
$commonName = "Microsoft.TeamFoundation.Common"
$clientName = "Microsoft.TeamFoundation.Client"
$VCClientName = "Microsoft.TeamFoundation.VersionControl.Client"
$WITClientName = "Microsoft.TeamFoundation.WorkItemTracking.Client"
$BuildClientName = "Microsoft.TeamFoundation.Build.Client"
$BuildCommonName = "Microsoft.TeamFoundation.Build.Common"

function New-Folder() {
    <#
    .SYNOPSIS
    This function creates new folders
    .DESCRIPTION
    This function will create a new folder if required or return a reference to
    the folder that was requested to be created if it already exists.
    .EXAMPLE
    New-Folder "C:TempMyNewFolder"
    .PARAMETER folderPath
    String representation of the folder path requested
    #>

    [CmdLetBinding()]
    param(
        [parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$folderPath
    )
    begin {}
    process {
        if (!(Test-Path -Path $folderPath)){
            New-Item -ItemType directory -Path $folderPath
        } else {
            Get-Item -Path $folderPath
        }
    }
    end {}
} #end Function New-Directory
{% endcodeblock %}
## First We Get Nuget

The first thing we need to do is get the Nuget.exe from the web. This is very easily down with the following PowerShell function
{% codeblock lang:powershell %}
function Get-Nuget(){
    <#
    .SYNOPSIS
    This function gets Nuget.exe from the web
    .DESCRIPTION
    This function gets nuget.exe from the web and stores it somewhere relative to
    the module folder location
    #>
    [CmdLetBinding()]
    param()

    begin{}
    process
    {
        #where to get Nuget.exe from
        $sourceNugetExe = "http://nuget.org/nuget.exe"

        #where to save Nuget.exe too
        $targetNugetFolder = New-Folder $("$ModuleRootNuget")
        $targetNugetExe = $("$ModuleRootNugetnuget.exe")

        try
        {
            # check if we have gotten nuget before
            $nugetExe = $targetNugetFolder.GetFiles() | ? {$_.Name -eq "nuget.exe"}
            if ($nugetExe -eq $null){
                #Get Nuget from a well known location on the web
                Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
            }
        }
        catch [Exception]
        {
            echo $_.Exception | format-list -force
        }

        #set an alias so we can use nuget syntactically the way we normally would
        Set-Alias nuget $targetNugetExe -Scope Global -Verbose
    }
    end{}
}
{% endcodeblock %}
Ok! When this function is invoked, we should now see a&nbsp;nuget.exe appear at:

>%USERPROFILE%\My Documents\WindowsPowerShell\Modules\MyTfsModule\Nuget\Nuget.exe

## Using Nuget to get TFS Client Object Model

Now that we have nuget, we need to get the TFS Client Object model from nuget.
{% codeblock lang:powershell %}
function Get-TfsAssembliesFromNuget(){
    <#
    .SYNOPSIS
    This function gets all of the TFS Object Model assemblies from nuget
    .DESCRIPTION
    This function gets all of the TFS Object Model assemblies from nuget and then
    creates a bin folder of all of the net45 assemblies so that they can be
    referenced easily and loaded as necessary
    #>
    [CmdletBinding()]
    param()

    begin{}
    process{
        #clear out bin folder
        $targetOMbinFolder = New-Folder $omBinFolder
        Remove-Item $targetOMbinFolder -Force -Recurse
        $targetOMbinFolder = New-Folder $omBinFolder
        $targetOMFolder = New-Folder $("$ModuleRootTFSOM")

        #get all of the TFS 2015 Object Model packages from nuget
        nuget install "Microsoft.TeamFoundationServer.Client" -OutputDirectory $targetOMFolder -ExcludeVersion -NonInteractive
        nuget install "Microsoft.TeamFoundationServer.ExtendedClient" -OutputDirectory $targetOMFolder -ExcludeVersion -NonInteractive
        nuget install "Microsoft.VisualStudio.Services.Client" -OutputDirectory $targetOMFolder -ExcludeVersion -NonInteractive
        nuget install "Microsoft.VisualStudio.Services.InteractiveClient" -OutputDirectory $targetOMFolder -ExcludeVersion -NonInteractive

        #Copy all of the required .dlls out of the nuget folder structure 
        #to a bin folder so we can reference them easily and they are co-located
        #so that they can find each other as necessary when loading
        $allDlls = Get-ChildItem -Path $("$ModuleRoot\TFSOM\") -Recurse -File -Filter "*.dll"
 
        # Create list of all the required .dlls
        #exclude portable dlls
        $requiredDlls = $allDlls | ? {$_.PSPath.Contains("portable") -ne $true } 
        #exclude resource dlls
        $requiredDlls = $requiredDlls | ? {$_.PSPath.Contains("resources") -ne $true } 
        #include net45, native, and Microsoft.ServiceBus.dll
        $requiredDlls = $requiredDlls | ? { ($_.PSPath.Contains("net45") -eq $true) -or ($_.PSPath.Contains("native") -eq $true) -or ($_.PSPath.Contains("Microsoft.ServiceBus") -eq $true) }
        #copy them all to a bin folder
        $requiredDlls | % { Copy-Item -Path $_.Fullname -Destination $targetOMBinFolder}
    }
    end{}
}
{% endcodeblock %}
This function does a could things. First it cleans out the existing bin folder, if it exists. Then it goes to nuget to get all of the packages that are available there. They are:

1. http://www.nuget.org/packages/Microsoft.VisualStudio.Services.Client/
2. http://www.nuget.org/packages/Microsoft.VisualStudio.Services.InteractiveClient/
3. http://www.nuget.org/packages/Microsoft.TeamFoundationServer.Client/
4. http://www.nuget.org/packages/Microsoft.TeamFoundationServer.ExtendedClient/

I use a number of switches on my invocation of the nuget.exe.

* -OutputDirectory – This sets the output directory for the nuget activities
* -ExcludeVersion – This tells Nuget not to append version numbers to package folders
* -NonInteractive – Don't prompt me for anything

The next part seems a bit verbose, but I'm leaving it that way as an example of achieving my intent in case you want to achieve something else. I am intending to get all of the net45, non-portable, base language (non-resource) assemblies from the directory structure that is created by nuget when getting the packages. In order to do that I:

1. Find all .dll files in the directory structure, recursively
2. Exclude .dll files that have "portable" in their path
3. Exclude .dll files that have "resource" in their path
4. Include only .dll files that have "net45″, "native", or "Microsoft.ServiceBus" in their path

After I've narrowed it down to that list of .dll files, I copy them all to the TFSOMbin folder where they will be referenced from. This also allows them to satisfy their dependencies on each other as required when loaded.

## Loading the TFS Object Models Assemblies

Now that we've retrieved the TFS Object model, and tucked it away in a bin folder we can find, we are now ready to load these assemblies into the PowerShell session that this module is in.
{% codeblock lang:powershell %}
function Import-TFSAssemblies() {
    <#
     .SYNOPSIS
     This function imports TFS Object Model assemblies into the PowerShell session
     .DESCRIPTION
     After the TFS 2015 Object Model has been retrieved from Nuget using
     Get-TfsAssembliesFromNuget function,  this function will import the necessary
     (given current functions) assemblies into the PowerShell session
    #>
    [CmdLetBinding()]
    param()

    begin{}
    process
    {
        $omBinFolder = $("$ModuleRootTFSOMbin");
        $targetOMbinFolder = New-Folder $omBinFolder;

        try {
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $vsCommon + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $commonName + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $clientName + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $VCClientName + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $WITClientName + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $BuildClientName + ".dll")
            Add-Type -LiteralPath $($targetOMbinFolder.PSPath + $BuildCommonName + ".dll")
        } 
        catch {
            $_.Exception.LoaderExceptions | $ { $_.Message }
        }
     }
     end{}
}
{% endcodeblock %}
## Putting the Object Model to Use

Now that we have the TFS Object Model loaded into this PowerShell session, we can use it! I'm going to show three&nbsp;functions. One that gets the TfsConfigurationServer object (basically your connection to the TFS server), one that gets the TeamProjectCollection Ids and a function that will get a list of all TFS Event Subscriptions on the server.

### Get-TfsConfigServer
{% codeblock lang:powershell %}
function Get-TfsConfigServer() {
    <#
    .SYNOPSIS
    Get a Team Foundation Server (TFS) Configuration Server object
    .DESCRIPTION
    The TFS Configuration Server is used for basic authentication and represents
    a connection to the server that is running Team Foundation Server.
    .EXAMPLE
    Get-TfsConfigServer "&lt;Url to TFS&gt;"
    .EXAMPLE
    Get-TfsConfigServer "http://localhost:8080/tfs"
    .EXAMPLE
    gtfs "http://localhost:8080/tfs"
    .PARAMETER url
     The Url of the TFS server that you'd like to access
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$url
    )
    begin {
        Write-Verbose "Loading TFS OM Assemblies for 2015 (14.83.0)"
        Import-TFSAssemblies
    }
    process {
        $retVal = [Microsoft.TeamFoundation.Client.TfsConfigurationServerFactory]::GetConfigurationServer($url)
        [void]$retVal.Authenticate()
        if(!$retVal.HasAuthenticated)
        {
            Write-Host "Not Authenticated"
            Write-Output $null;
        } else {
            Write-Host "Authenticated"
            Write-Output $retVal;
        }
    }
    end {
        Write-Verbose "ConfigurationServer object created."
    }
} #end Function Get-TfsConfigServer
{% endcodeblock %}
This function takes a Url and returns an instance of a&nbsp;Microsoft.TeamFoundation.Client.TfsConfigurationServer. This connection object will be authenticated (via Windows Integrated Authentication). If you don't have permission within the domain to administer the TFS server, you won't be able to use the functions provided by the object model. The other functions require this connection in order to do their additional work.

### Get-TfsProjectCollections
{% codeblock lang:powershell %}
function Get-TfsTeamProjectCollectionIds() {
    <#
    .SYNOPSIS
    Get a collection of Team Project Collection (TPC) Id
    .DESCRIPTION
    Get a collection of Team Project Collection (TPC) Id from the server provided
    .EXAMPLE
    Get-TfsTeamProjectCollectionIds $configServer
    .EXAMPLE
    Get-TfsConfigServer "http://localhost:8080/tfs" | Get-TfsTeamProjectCollectionIds
    .PARAMETER configServer
    The TfsConfigurationServer object that represents a connection to TFS server that you'd
    like to access
    #>
    [CmdLetBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Microsoft.TeamFoundation.Client.TfsConfigurationServer]$configServer
    )
    begin{}
    process{
        # Get a list of TeamProjectCollections
        [guid[]]$types = [guid][Microsoft.TeamFoundation.Framework.Common.CatalogResourceTypes]::ProjectCollection
        $options = [Microsoft.TeamFoundation.Framework.Common.CatalogQueryOptions]::None
        $configServer.CatalogNode.QueryChildren( $types, $false, $options) | % { $_.Resource.Properties["InstanceId"]}
    }
    end{}
} #end Function Get-TfsTeamProjectCollectionIds
{% endcodeblock %}
### Get-TfsEventSubscriptions

We are using a 3rd party tool that subscribes to build events and we needed to know if it was releasing those subscriptions properly and also discover where this tool was running.&nbsp;We thought that the easiest way to do this was to look at all of the subscriptions in the TFS Project Collections in our AppTier.
{% codeblock lang:powershell %}
#adapted from http://blogs.msdn.com/b/alming/archive/2013/05/06/finding-subscriptions-in-tfs-2012-using-powershell.aspx
function Get-TFSEventSubscriptions() {

    [CmdLetBinding()]
    param(
        [parameter(Mandatory = $true)]
        [Microsoft.TeamFoundation.Client.TfsConfigurationServer]$configServer
    )

    begin{}
    process{
        $tpcIds = Get-TfsTeamProjectCollectionIds $configServer
        foreach($tpcId in $tpcIds)
        {
            #Get TPC instance
            $tpc = $configServer.GetTeamProjectCollection($tpcId)
            #TFS Services to be used
            $eventService = $tpc.GetService("Microsoft.TeamFoundation.Framework.Client.IEventService")
            $identityService = $tpc.GetService("Microsoft.TeamFoundation.Framework.Client.IIdentityManagementService")

            foreach ($sub in $eventService.GetAllEventSubscriptions())
            {
                #First resolve the subscriber ID
                $tfsId = $identityService.ReadIdentity(
                    [Microsoft.TeamFoundation.Framework.Common.IdentitySearchFactor]::Identifier,
                    $sub.Subscriber,
                    [Microsoft.TeamFoundation.Framework.Common.MembershipQuery]::None,
                    [Microsoft.TeamFoundation.Framework.Common.ReadIdentityOptions]::None )

                if ($tfsId.UniqueName)
                {
                    $subscriberId = $tfsId.UniqueName
                }
                else
                {
                    $subscriberId = $tfsId.DisplayName
                }

                #then create custom PSObject
                $subPSObj = New-Object PSObject -Property @{
                    AppTier = $tpc.Uri
                    ID = $sub.ID
                    Device = $sub.Device
                    Condition = $sub.ConditionString
                    EventType = $sub.EventType
                    Address = $sub.DeliveryPreference.Address
                    Schedule = $sub.DeliveryPreference.Schedule
                    DeliveryType = $sub.DeliveryPreference.Type
                    SubscriberName = $subscriberId
                    Tag = $sub.Tag
               }

               #Send object to the pipeline. You could store it on an Arraylist, but that just
               #consumes more memory
               $subPSObj

               #This is another variation where we just add a property to the existing Subscription object
               #this might be desirable since it will keep the other members
               #Add-Member -InputObject $sub -NotePropertyName SubscriberName -NotePropertyValue $subscriberId
           }
       }
   }
   end{}
}
{% endcodeblock %}

## All Done

We are now all done creating our initial MyTfsModule implementation! We should be able to load it up now and give it a spin!

![MyTfsModule_In_Action][3]

I've obscured the name of my running module and TFS server, but in those spots, just use the name of your module and TFS server.
{% codeblock lang:powershell %}
Import-Module MyTfsModule
$configServer = Get-TfsConfigServer http://<name of your TFS server>:8080/tfs
$allEventsOnServer = Get-TfsEventSubscriptions $configServer
$allEventsOnServer.Length
{% endcodeblock %}
## Final Thoughts

The key takeaway from this post was that it is great that we can now get the TFS Object Model from Nuget. Still a bit of a pain to sort and move the downloaded assemblies&nbsp;around, but this is because we I am using PowerShell and not building some sort of C#-based project in Visual Studio which would handle the nuget packages much more elegantly.

I hope this post gives you the information you need to go off and create&nbsp;your own TFS PowerShell module without having to install Visual Studio first!

p.s. I do have a version of this module that loads the assemblies from the install location of Visual Studio. I'll visit that shortly in another blog post.

[1]: https://www.visualstudio.com/
[2]: http://www.nuget.org/
[3]: https://agileramblings.files.wordpress.com/2015/07/mytfsmodule_in_action.png?w=502&amp;h=176
