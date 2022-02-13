function Get-ICContact {
    [CmdletBinding()]
    param (
           )

    Begin {
        $url = $Script:_IcUri
        $token = $Script:_IcToken
        
        if (!$url -or !$token) {
            throw "You must call the Connect-IC cmdlet before calling any other cmdlets."
        }

        $headers = @{
            Authorization = "Bearer $token"
            Accept = 'application/json'
        }
    }

    Process {
        $path = '/inContactAPI/services/v23.0/contacts/active'
        $uri = [uri]::new($url, $path)

#        (Invoke-RestMethod -Uri $uri -Headers $headers).activeContacts
        (Invoke-RestMethod -Uri $uri -Headers $headers)
    }
}