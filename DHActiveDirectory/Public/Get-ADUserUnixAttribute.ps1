#Requires -Module ActiveDirectory
function Get-ADUserUnixAttribute {
    [CmdletBinding()]
    param(
        [Parameter()]
        [Microsoft.ActiveDirectory.Management.ADAccount[]]$Identity
    )
    begin {}

    process {
        foreach ($User in $Identity) {
            $UserProperties = Get-ADUser -Identity $User -Properties uidNumber
            $UnixAttributes = [PSCustomObject]@{
                SamAccountName    = $UserProperties.SamAccountName
                uidNumber         = $UserProperties.uidNumber
                gidNumber         = $UserProperties.gidNumber
                primaryGroupID    = $UserProperties.primaryGroupID
                loginShell        = $UserProperties.loginShell
                unixHomeDirectory = $UserProperties.unixHomeDirectory
            }
            $UnixAttributes
        }
    }

    end {}
}