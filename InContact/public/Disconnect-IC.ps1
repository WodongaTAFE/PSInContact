<#
.SYNOPSIS
Disconnects from the connected inContact instance.
.DESCRIPTION
Clears cached credentials for the connected inContact instance.
#>
function Disconnect-IC {
    [CmdletBinding()]
    param()

    Remove-Variable -Scope Script -Name _ICUri
    Remove-Variable -Scope Script -Name _ICToken
}