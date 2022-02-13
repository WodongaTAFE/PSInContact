function Get-ICUnassignedPhoneNumbers {
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [Alias('search')]
        [string] $searchString
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
        $path = '/inContactAPI/services/v23.0/phone-numbers'
        if($searchString){
            $path = $path + "?searchString=$searchString"
        }
        $uri = [uri]::new($url, $path)

        (Invoke-RestMethod -Uri $uri -Headers $headers).phoneNumbers
    }
}