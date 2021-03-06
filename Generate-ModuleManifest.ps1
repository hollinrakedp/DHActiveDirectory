$ModuleName = $PSScriptRoot | Split-Path -Leaf
$FunctionsToExport = @( (Get-ChildItem -Path $PSScriptRoot\$ModuleName\Public\*.ps1).BaseName )

$manifest = @{
    Path              = "$PSScriptRoot\$ModuleName\$ModuleName.psd1"
    RootModule        = "$ModuleName.psm1"
    Author            = 'Darren Hollinrake'
    Company           = 'Darren Hollinrake'
    Description       = 'Collection of custom scripts and functions for managing Active Directory'
    ModuleVersion     = '0.1'
    FunctionsToExport = $FunctionsToExport
}

if (Test-Path $manifest.Path){
    Update-ModuleManifest @manifest
}
else {
    New-ModuleManifest @manifest
}