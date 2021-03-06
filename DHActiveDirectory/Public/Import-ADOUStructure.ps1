function Import-ADOUStructure {
    <#
    .SYNOPSIS
    Import an OU structure from a CSV file.

    .DESCRIPTION
    This function will create an OU structure based on the DN's imported from a CSV file. The CSV file should be tab delimited. The header must contain 'DistinguishedName' to import correctly. If a 'Description' column is included, the description will be added to the OU. Additional columns may exist but are not necessary.

    Note: OU's should be ordered within the CSV to ensure the are created in hierarchical order. I.E. An OU containing other OU's needs to be created first. Failure to do may result some OU's not being created.

    You can create a CSV from an existing AD infrastructure. Sorting by Canonical Name will ensure it is created in hierarchical order.
        Get-ADOrganizationalUnit -Filter * -Properties CanonicalName | Sort-Object CanonicalName `
        | select DistinguishedName,Description | Export-Csv -Delimiter '`t' -Path OU.csv

    CSV File Example
    ---------------------------------
    "DistinguishedName","Description"
    "OU=Test,DC=lab,DC=lan","Base OU"
    "OU=Groups,OU=Test,DC=lab,DC=lan","My Groups"
    "OU=Users,OU=Test,DC=lab,DC=lan","My Users"
    ---------------------------------

    .NOTES
    Name         - Import-ADOUStructure
    Version      - 0.5
    Author       - Darren Hollinrake
    Date Created - 2022-03-25
    Date Updated - 2022-05-03

    .EXAMPLE
    Import-ADOUStructure -Path ".\OU.csv"
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
            Write-Output "`tSkipping: OU exists"
        }
        catch {
            if ($OU.PSobject.Properties.name -match "Description") {
                Write-Verbose "A Description property was provided"
                $params = @{
                    name = (($OU.DistinguishedName -split ',')[0] -split '=')[1]
                    path = $OU.DistinguishedName.TrimStart(($OU.DistinguishedName -split ',')[0]).TrimStart(',')
                    Description = "$($OU.Description)"
                }
            } else {
                Write-Verbose "No Description property provided"
                $params = @{
                    name = (($OU.DistinguishedName -split ',')[0] -split '=')[1]
                    path = $OU.DistinguishedName.TrimStart(($OU.DistinguishedName -split ',')[0]).TrimStart(',')
                }
            }
            Write-Output "`tCreating OU"
            New-ADOrganizationalUnit @params
        }
    }
}