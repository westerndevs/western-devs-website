$EnvName = Read-Host "Name for Azure Resource Group (must be globally unique and all lowercase)?"

$RemoteScriptPath = Join-Path $PSScriptRoot "putty.sh"
$UpdatedRemoteScriptPath = Join-Path $PSScriptRoot "$EnvName.sh"
$BashFile = (Get-Content $RemoteScriptPath) | Foreach-Object {$_ -replace '\[resourceGroup\]',$EnvName}
$TemplateFile = Join-Path $PSScriptRoot "wddocker.json"

$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
[System.IO.File]::WriteAllLines($UpdatedRemoteScriptPath, $BashFile, $Utf8NoBomEncoding)

Add-AzureAccount
Get-AzureSubscription | Format-Wide
$AzureSub = Read-Host "What Azure Subscription (one of the values above)?"
Select-AzureSubscription $AzureSub

Switch-AzureMode AzureResourceManager

New-AzureResourceGroup -Location "West US" -Name $EnvName -TemplateFile $TemplateFile -verbose

$PlinkPath = Join-Path $PSScriptRoot "plink.exe"
$PlinkArgs = "-ssh $EnvName.westus.cloudapp.azure.com -l WesternDevs -pw P2ssw0rd -m $UpdatedRemoteScriptPath"

Write-Host "Running: $PlinkPath $PlinkArgs"
Invoke-Expression "echo y | $PlinkPath -ssh WesternDevs@$EnvName.westus.cloudapp.azure.com 'exit'" | Out-Null
Start-Process $PlinkPath -ArgumentList $PlinkArgs

Write-Host "Once the plink command window says Server Running you can browse to your site at http://$EnvName.westus.cloudapp.azure.com:4000"