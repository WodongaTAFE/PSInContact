<#
.SYNOPSIS
Disconnects from the connected inContact instance.
.DESCRIPTION
Clears cached credentials for the connected inContact instance.
#>
function Disconnect-IC {
    [CmdletBinding()]
    param()

    $PsCmdlet.SessionState.PSVariable.Remove('_ICUri')
    $PsCmdlet.SessionState.PSVariable.Remove('_ICToken')
}