function Get-ICAddressBook {
    [CmdletBinding()]
    param ()

    Begin {
        $url = $PsCmdlet.SessionState.PSVariable.GetValue("_ICUri")
        $token = $PsCmdlet.SessionState.PSVariable.GetValue("_ICToken")
        
        if (!$url -or !$token) {
            throw "You must call the Connect-IC cmdlet before calling any other cmdlets."
        }

        $headers = @{
            Authorization = "Bearer $token"
            Accept = 'application/json'
        }
    }

    Process {
        $path = '/inContactAPI/services/v20.0/address-books'
        $uri = [uri]::new($url, $path)

        (Invoke-RestMethod -Uri $uri -Headers $headers).addressBooks
    }
}