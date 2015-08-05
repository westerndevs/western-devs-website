Set-StrictMode -Version 3
Import-Module Azure -ErrorAction SilentlyContinue

$EnvName = Read-Host "Name for Azure Resource Group (must be globally unique and all lowercase)?"
$BranchName = Read-Host "Name of branch in git?"

Add-AzureAccount
Get-AzureSubscription | Format-Wide
$AzureSub = Read-Host "What Azure Subscription (one of the values above)?"
Select-AzureSubscription $AzureSub

Switch-AzureMode AzureResourceManager

$TemplateFile = Join-Path $PSScriptRoot "wddocker.json"
$params = @{branchName="$BranchName"}
New-AzureResourceGroup -Location "West US" -Name $EnvName -TemplateFile $TemplateFile -TemplateParameterObject $params -verbose

Read-Host "Press enter to launch a browser to your new site - if it gives an error wait a minute then refresh"
Start-Process "http://$EnvName.westus.cloudapp.azure.com:4000"