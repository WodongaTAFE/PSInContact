function Get-ICAgentTeam {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName, ParameterSetName='id')]
        [Alias('Id')]
        [int] $TeamId,

        [Parameter(ParameterSetName='notid')]
        [Alias('Active')]
        [bool] $IsActive,

        [Parameter(ParameterSetName='notid')]
        [Alias('SearchText')]
        [string] $SearchString
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
        if ($TeamId) {
            $path = "/inContactAPI/services/v20.0/teams/$TeamId"
        }
        else {
            $path = '/inContactAPI/services/v20.0/teams?'
            if ($PSBoundParameters.ContainsKey('IsActive')) {
                $path += "isActive=$IsActive&"
            }
            if ($SearchString) {
                $path += "searchString=$SearchString&"
            }
        }
        $uri = [uri]::new($url, $path)

        (Invoke-RestMethod -Uri $uri -Headers $headers).teams
    }
}