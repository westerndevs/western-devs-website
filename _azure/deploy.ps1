Set-StrictMode -Version 3
Import-Module Azure -ErrorAction SilentlyContinue

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
    $AllSubscriptions | Format-Table -Property SubscriptionName
    $AzureSub = Read-Host "What Azure Subscription (one of the values above)?"
    Select-AzureSubscription $AzureSub
}

Switch-AzureMode AzureResourceManager

$TemplateFile = Join-Path $PSScriptRoot "wddocker.json"
$params = @{branchName="$BranchName"}
New-AzureResourceGroup -Location "West US" -Name $EnvName -TemplateFile $TemplateFile -TemplateParameterObject $params -verbose

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