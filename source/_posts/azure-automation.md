---
title:  Azure Automation
# Powershell Gotchas
# Example Script
authorId: simon_timms
date: 2021-06-24
originalurl: https://blog.simontimms.com/2021/06/24/azure-automation
mode: public
---



Azure Automation is a service that allows running small scripts to do automation of tasks inside azure. For instance if you want to scale a database up and down depending on the time of day this is an ideal place to do it. 

There are basically 3 concepts in it

1. Runbook - a script that you write and publish from within Azure Automation. The supported languages include Python (2 and 3!) and powershell. There is also a graphical builder which basically just run powershell commandlets
![](/images/2021-06-24-azure-automation.md/2021-06-24-07-05-52.png))
2. Jobs - executions of the runbook. These can take parameters and pass them off to a runbook. The job logs what it is doing but the logging is a bit sketchy. You should consider reviewing the json output to see exactly what went wrong with your job instead of relying on the UI. 
3. Schedule - You can kick off a job at any point in time using a schedule. Schedules allow passing parameters to the jobs.

## Powershell Gotchas

For some reason, likely the typical Microsoft support of legacy software, the Azure modules included in powershell by default are the old AzureRM ones and not the newer, more awesome Az modules. You can go to the module gallery to install more modules 
![](/images/2021-06-24-azure-automation.md/2021-06-24-07-11-22.png))
However, little problem with that is that the module installation process doesn't handle dependencies so if you want to install something like Az.Sql which relies on Az.Account then you need to go install Az.Account first. The installation takes way longer than you'd logically expect so I sure hope you don't need to install something like Az proper which has 40 dependencies.

## Example Script

This script will scale a database to the desired level

```powershell


Param(
 [string]$ResourceGroupName,
 [string]$ServerName,
 [string]$DatabaseName,
 [string]$TargetEdition,
 [string]$TargetServiceObjective
)

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Connect-AzAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}


echo "Scaling the database"
Set-AzSqlDatabase -ResourceGroupName $ResourceGroupName -DatabaseName $DatabaseName -ServerName $ServerName -Edition $TargetEdition -RequestedServiceObjectiveName $TargetServiceObjective
echo "Scaling complete"
```