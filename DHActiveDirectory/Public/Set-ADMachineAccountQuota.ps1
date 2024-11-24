#Requires -Module ActiveDirectory
function Set-ADMachineAccountQuota {
    <#
    .SYNOPSIS
    Sets the machine account quota for an Active Directory domain.

    .DESCRIPTION
    The Set-ADMachineAccountQuota function modifies the ms-DS-MachineAccountQuota attribute
    of an Active Directory domain, which determines how many computer accounts a user can add
    to the domain.

    .NOTES
    Name        : Set-ADMachineAccountQuota
    Author      : Darren Hollinrake
    Version     : 1.1
    Date Created: 2023-12-17
    Date Updated: 2024-11-24

    .PARAMETER Identity
    Specifies the Active Directory domain by Distinguished Name (DN).
    If not specified, defaults to the current domain.

    .PARAMETER Quota
    Specifies the new machine account quota value.
    Default value is 0.

    .EXAMPLE
    Set-ADMachineAccountQuota -Quota 10
    Sets the machine account quota to 10 for the current domain.

    .EXAMPLE
    Set-ADMachineAccountQuota -Identity "DC=contoso,DC=com" -Quota 5
    Sets the machine account quota to 5 for the specified domain.

    .LINK
    https://docs.microsoft.com/en-us/windows/win32/adschema/a-ms-ds-machineaccountquota

    #>
    param (
        [Parameter()]
        [string]$Identity = (Get-ADDomain).DistinguishedName,
        [Parameter()]
        [int]$Quota = 0
    )

    process {
        try {
            Set-ADDomain -Identity $Identity -Replace @{ 'ms-DS-MachineAccountQuota' = $Quota }

            Write-Output "Machine account quota set to $Quota successfully."
        }
        catch {
            Write-Error "Failed to set machine account quota. $_"
        }
    }

}