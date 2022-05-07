<#
.SYNOPSIS
Creates the AD Central Policy Store.

.DESCRIPTION
This creates the Central Policy Store for the Active Directory Domain. Run this script on a domain controller. This will copy the local C:\Windows\PolicyDefinitions folder to C:\Windows\SYSVOL\domain\Policies

.NOTES
Name        : Add-ADCentralStore.ps1
Author      : Darren Hollinrake
Version     : 1.0
Date Created: 2022-05-07
Date Updated: 

#>
$OSInfo = Get-CimInstance -ClassName Win32_OperatingSystem
if ($OSInfo.ProductType -eq 2) {
    if (!(Test-Path "C:\Windows\SYSVOL\domain\Policies\PolicyDefinitions")) {
        Write-Verbose "Central Store doesn't exist, creating it now."
        Copy-Item -Path "C:\Windows\PolicyDefinitions" -Destination "C:\Windows\SYSVOL\domain\Policies" -Recurse
    }
    else {
        Write-Output "Central Store already exists. Nothing to do."
    }
}
else {
    Write-Error "You must be on a Domain Controller to run this script"
}