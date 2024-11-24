#Requires -Module ActiveDirectory

function Get-ADMachineAccountQuota {
    <#
    .SYNOPSIS
    Gets the Machine Account Quota for an Active Directory domain.

    .DESCRIPTION
    Retrieves the ms-DS-MachineAccountQuota attribute value from Active Directory, which determines how many computer accounts a user can create in the domain.

    .NOTES
    Name        : Get-ADMachineAccountQuota
    Author      : Darren Hollinrake
    Version     : 1.1
    Date Created: 2023-12-17
    Date Updated: 2024-11-24

    .PARAMETER Identity
    The distinguished name of the domain. If not specified, the current domain is used.

    .EXAMPLE
    Get-ADMachineAccountQuota
    Returns the Machine Account Quota for the current domain.

    .EXAMPLE
    Get-ADMachineAccountQuota -Identity "DC=contoso,DC=com"
    Returns the Machine Account Quota for the specified domain.

    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Identity = (Get-ADDomain).DistinguishedName
    )

    process {
        try {
            $Quota = Get-ADObject -Identity $Identity -Properties ms-DS-MachineAccountQuota -ErrorAction Stop
            $Quota.'ms-DS-MachineAccountQuota'
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
            Write-Error "The specified domain object was not found: $Identity"
        }
        catch {
            Write-Error "Failed to retrieve the Machine Account Quota: $_"
        }
    }
}