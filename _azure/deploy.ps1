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