function Get-ICAddressBookEntry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $AddressBookId,

        [Alias('SearchText')]
        [string] $SearchString
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
        $path = "/inContactAPI/services/v20.0/address-books/$AddressBookId/entries?"
        if ($SearchString) {
            $path += "searchString=$SearchString"
        }
        $uri = [uri]::new($url, $path)

        (Invoke-RestMethod -Uri $uri -Headers $headers).addressBook.addressBookEntries
    }
}