
function Get-ICCampaign {
    [CmdletBinding()]
    param (
        [Alias('Active')]
        [bool] $IsActive,

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
        $path = '/inContactAPI/services/v20.0/campaigns?'
        if ($PSBoundParameters.ContainsKey('IsActive')) {
            $path += "isActive=$IsActive&"
        }
        if ($SearchString) {
            $path += "searchString=$SearchString&"
        }
        $uri = [uri]::new($url, $path)

        (Invoke-RestMethod -Uri $uri -Headers $headers).resultset.campaigns
    }
}