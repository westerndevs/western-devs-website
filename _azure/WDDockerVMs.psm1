Write-Host "Loading WD-VMs Module"
Set-StrictMode -Version Latest

try
{
    Import-Module Azure -ErrorAction Stop
}
catch [Exception]
{
	echo $_.Exception | Format-List -force
}

function Get-MyAzureSubscription(){
<# 
    .SYNOPSIS
    Get your Azure Account connected to PowerShell
    .DESCRIPTION
    This method will take your MSA account id as an optional parameter and connect PowerShell to Azure using that Azure account. 
    If the account is not already connected, you will be presented with a Login browser window where you should enter your Azure Credentials
    .EXAMPLE
    Get-MyAzureSubscription -AzureAccountName me@yourdomain.com
    .PARAMETER accountName
    Your Microsoft Account Name in the form of an email address
     
#>
    [CmdLetBinding()]
    param(
        [parameter(Mandatory = $false)]
        [Alias("AzureAccountName")]
        [string] $accountName
    )
    begin{}
    process
    {
        $loadedAccounts = Get-AzureAccount
        if (($accountName -eq $null) -or (($loadedAccounts | ? {$_.Id -eq $accountName}) -eq $null)){
            Add-AzureAccount | Out-Null
        }
        $subs = Get-AzureSubscription
        $i = 0;
        foreach($sub in $subs){
            Write-Host "[$i] - $($sub.SubscriptionName)"
            $i++
        }
    }
    end{}

}

function Select-MyAzureSubscription(){
<# 
    .SYNOPSIS
    Set your Azure Subscription as Active in the PowerShell session
    .DESCRIPTION
    This function will use the index value to select one of all currently available subscriptions in the PowerShell session and make it the Active subscription
    .EXAMPLE
    Get-MyAzureSubscription -Index 0
    .PARAMETER accountName
    The index of the subscription you would like to activate
#>
    [CmdLetBinding()]
    param(
        [parameter(Mandatory = $true)]
        [Alias("Index")]
        [int] $number
    )
    begin{}
    process
    {
        $subs = Get-AzureSubscription
        Select-AzureSubscription $subs[$number].SubscriptionName
        Write-Host "The subscription named " -NoNewline
        Write-Host $($subs[$number].SubscriptionName) -NoNewline -ForegroundColor Green
        Write-Host " was selected."
    }
    end{}
}

function Add-DockerVM(){
<# 
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
    .PARAMETER resourceGroupName
     The desired name for Docker VM (must be globally unique and all lowercase)
     This manifests as an AzureResourceGroup in Azure with a VM of the same name
    .PARAMETER gitBranchName
     Name of branch in git to pull the website source from
#>
	[CmdletBinding()]
	param(
        [parameter(Mandatory = $true)]
        [Alias("DockerName")]
        [string] $dockerVMName,
        [parameter(Mandatory = $true)]
        [Alias("GitBranch")]
        [string] $gitBranchName
    )
	begin{}
	process{
        $EnvName = $dockerVMName.ToLower()
        $BranchName = $gitBranchName.ToLower()

        Switch-AzureMode AzureResourceManager

        $TemplateFile = Join-Path $PSScriptRoot "wddocker.json"
        if ((Test-Path -Filter File -LiteralPath $TemplateFile) -eq $false){
            Write-Host "Downloading latest version of wddocker.json from GitHub"
            $client = (New-Object Net.WebClient)
            $client.DownloadFile("https://raw.githubusercontent.com/westerndevs/western-devs-website/source/_azure/wddocker.json", $templateFile)
        }
        if ((Test-Path -Filter File -LiteralPath $TemplateFile)){
            $params = @{branchName="$BranchName"}
            try {
                $response = New-AzureResourceGroup -Location "West US" -Name $EnvName -TemplateFile $TemplateFile -TemplateParameterObject $params
                if (($response -ne $null) -and ($response.Resources.Count -eq 7)){
                     Write-Host "You're new Docker-enabled VM was provisioned."
                     Write-Host "Launching a browser to your new site - if it gives an error wait a minute then refresh"
                     Write-Host "URL: http://$EnvName.westus.cloudapp.azure.com:4000 "
                     Start-Process "http://$EnvName.westus.cloudapp.azure.com:4000"
                } else {
                    Write-Host "There was a problem provisioning your Docker-enabled VM. Please review the error message and try again."
                }
            }
            catch {
               echo $_.Exception | Format-List -force
            }
        } else {
            Write-Error "Failed to download a required template file for the WDDockerVMs module."
        }
    }
	end{}
}

function Remove-DockerVM(){
	[CmdletBinding()]
	param(       
        [parameter(Mandatory = $true)]
        [Alias("DockerName")]
        [string] $dockerVMName
    )
	begin{}
	process{
        $resourceGroupName = $dockerVMName.ToLower()
        $resourceGroups = Get-AzureResourceGroup
        if ($resourceGroups | ? {$_.ResourceGroupName -eq $resourceGroupName}){
            Remove-AzureResourceGroup -Name $resourceGroupName
        } else {
            Write-Host "There is no DockerVM with the name " -NoNewline
            Write-Host $resourceGroupName -ForegroundColor Green
        }
    }
	end{}
}