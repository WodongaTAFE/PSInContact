function Remove-ICAddressBookEntry {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $AddressBookId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $AddressBookEntryId
    )

    Begin {
        $url = $PsCmdlet.SessionState.PSVariable.GetValue("_ICUri")
        $token = $PsCmdlet.SessionState.PSVariable.GetValue("_ICToken")
        
        if (!$url -or !$token) {
            Throw "You must call the Connect-IC cmdlet before calling any other cmdlets."
        }

        $headers = @{
            Authorization = "Bearer $token"
            Accept = 'application/json'
        }
    }

    Process {
        $path = "/inContactAPI/services/v20.0/address-books/$AddressBookId/entries/$AddressBookEntryId"
        $uri = [uri]::new($url, $path)

        if ($PSCmdlet.ShouldProcess("Address book $AddressBookId", "Removing entry $AddressBookEntryId")) {
            Invoke-RestMethod -Method Delete -Uri $uri -Headers $headers
        }
    }
}