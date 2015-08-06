(new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/westerndevs/western-devs-website/source/_azure/Get-WDDockerVMs.ps1") | iex

impo WDDockerVMs

$EnvName = Read-Host "Name for Docker VM (must be globally unique and all lowercase)?"
$BranchName = Read-Host "Name of branch in git?"

Get-MyAzureSubscription
$id = Read-Host "What Azure Subscription (use index number of one of the entries above)?"
Select-MyAzureSubscription $id

Request-DockerVM $EnvName $BranchName

# Prompt to Delete DockerVM ResourceGroup
$deleteVM = Read-Host "Would you like to delete the Docker VM now? (y/n)"
if ($deleteVM.ToLower() -eq 'y' ){
	Remove-DockerVM $EnvName
}