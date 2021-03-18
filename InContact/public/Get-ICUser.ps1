function Get-ICUser {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [Alias('id')]
        [string] $UserId,

        [Parameter(ParameterSetName='notid')]
        [Alias('SearchText')]
        [string] $SearchString
    )

    begin {
        $url = $Script:_IcUri
        $token = $Script:_IcToken
        
        if (!$url -or !$token) {
            throw 'You must call the Connect-IC cmdlet before calling any other cmdlets.'
        }
    
        $headers = @{
            Authorization = "Bearer $token"
            Accept = 'application/json'
        }
    }

    process {
        if ($UserId) {
            $path = "/user-management/v1/users/$UserId"

            $uri = [uri]::new($url, $path)
            (Invoke-RestMethod -Uri $uri -Headers $headers).user
        }
        else {
            $path = '/user-management/v1/users?'
            if ($SearchString) {
                $path += "fullNameContains=$SearchString&"
            }

            $uri = [uri]::new($url, $path)
            (Invoke-RestMethod -Uri $uri -Headers $headers).users
        }
    }
}