function Test-ADOUStructure {
    <#
    .SYNOPSIS
    Compare your AD OU structure against a CSV file.

    .DESCRIPTION
    This function will compare the existing OU structure against the contents of a CSV file.

    CSV File Example
    ---------------------------------
    "DistinguishedName","Description"
    "OU=Test,DC=lab,DC=lan","Base OU"
    "OU=Groups,OU=Test,DC=lab,DC=lan","My Groups"
    "OU=Users,OU=Test,DC=lab,DC=lan","My Users"
    ---------------------------------

    .NOTES
    Name         - Test-ADOUStructure
    Version      - 0.1
    Author       - Darren Hollinrake
    Date Created - 2022-05-03
    Date Updated - 

    .EXAMPLE
    Test-ADOUStructure -Path ".\OU.csv"
    OU: OU=Test,DC=lab,DC=lan
        Creating OU
    OU: OU=Groups,OU=Test,DC=lab,DC=lan
        Creating OU
    OU: OU=Users,OU=Test,DC=lab,DC=lan
        Creating OU

    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [System.IO.FileInfo]$Path
    )
    if (!(Test-Path $Path -PathType Leaf)) {
        Write-Warning "The file specified for '-Path' does not exist."
        return
    }
    $OUs = Import-Csv "$Path"
    foreach ($OU in $OUs) {
        Write-Output "OU: $($OU.DistinguishedName)"
        try {
            Get-ADOrganizationalUnit -Identity $OU.DistinguishedName | Out-Null
            Write-Output "`tExists"
        }
        catch {
            Write-Error "`tMISSING"
        }
    }
}