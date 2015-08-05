Set-StrictMode -Version 3
Import-Module Azure -ErrorAction SilentlyContinue

$EnvName = Read-Host "Name for Azure Resource Group (must be globally unique and all lowercase)?"
$BranchName = Read-Host "Name of branch in git?"

$RemoteScriptPath = Join-Path $PSScriptRoot "putty.sh"
$UpdatedRemoteScriptPath = Join-Path $PSScriptRoot "$EnvName.sh"

$BashFile = (Get-Content $RemoteScriptPath) | Foreach-Object {$_ -replace '\[resourceGroup\]',$EnvName}
$BashFile = $BashFile | Foreach-Object {$_ -replace '\[branchName\]',$BranchName}
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
[System.IO.File]::WriteAllLines($UpdatedRemoteScriptPath, $BashFile, $Utf8NoBomEncoding)

Add-AzureAccount
Get-AzureSubscription | Format-Wide
$AzureSub = Read-Host "What Azure Subscription (one of the values above)?"
Select-AzureSubscription $AzureSub

Switch-AzureMode AzureResourceManager

$TemplateFile = Join-Path $PSScriptRoot "wddocker.json"
New-AzureResourceGroup -Location "West US" -Name $EnvName -TemplateFile $TemplateFile -verbose

$PlinkPath = Join-Path $PSScriptRoot "plink.exe"
$PlinkArgs = "-ssh $EnvName.westus.cloudapp.azure.com -l WesternDevs -pw P2ssw0rd -m $UpdatedRemoteScriptPath"

# This will suppress the prompt that the server is untrusted for all future plink commands
Write-Host "Note: The below error is expected - I just haven't figured out how to suppress the scary error text yet"
Invoke-Expression "echo y | $PlinkPath -ssh WesternDevs@$EnvName.westus.cloudapp.azure.com 'exit'" -ErrorAction SilentlyContinue | Out-Null
Write-Host "======================"

Write-Host "Running: $PlinkPath $PlinkArgs"
Start-Process $PlinkPath -ArgumentList $PlinkArgs
Write-Host "======================"

Write-Host "Once the plink command window says Server Running you can browse to your site at http://$EnvName.westus.cloudapp.azure.com:4000"
Read-Host "Press enter to close this window..."