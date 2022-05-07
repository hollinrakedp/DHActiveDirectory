#Requires -Module ActiveDirectory
function Get-GPOAuditRule {
    <#
    .SYNOPSIS
    Retreives Audit Rules on GPOs

    .DESCRIPTION
    This function will retrieve the audit rules on GPOs.

    .NOTES
    Name        : Get-GPOAuditRule
    Author      : Darren Hollinrake
    Version     : 1.0
    Date Created: 2022-05-07
    Date Updated: 

    .PARAMETER Name
    Provide the display name of one or more GPOs. The audit rules configured on the specified GPO(s) will be returned.

    .PARAMETER Guid
    Provide the GUID of one or more GPOs. The audit rules configured on the specified GPO(s) will be returned.

    .PARAMETER All
    The audit rules configured on all the GPOs will be returned.

    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName,
            ParameterSetName = 'Name')]
        [string[]]$Name,
        [Parameter(ValueFromPipelineByPropertyName,
            ParameterSetName = 'Guid')]
        [string[]]$Guid,
        [Parameter(ValueFromPipelineByPropertyName,
            ParameterSetName = 'All')]
        [switch]$All
    )
    # Explicitly importing the module is required to get the AD:\ drive
    Import-Module ActiveDirectory

    switch ($PSBoundParameters.Keys) {
        Name {
            $GPOs = Get-GPO -Name $Name
        }

        Guid {
            $GPOs = Get-GPO -Guid $Guid
        }

        All {
            $GPOs = Get-GPO -All
        }
    }
    foreach ( $GPO in $GPOs ) {
        $DisplayName = $GPO.DisplayName
        Write-Output "Viewing GPO: $DisplayName"
        $Path = "AD:\" + $GPO.Path
        $ACL = Get-Acl -Path $Path
        $ACL.Audit
    }
}