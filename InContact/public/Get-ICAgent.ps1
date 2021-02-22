function Get-ICAgent {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [Alias('id')]
        [string] $AgentId,

        [Parameter(ParameterSetName='notid')]
        [Alias('Active')]
        [bool] $IsActive,

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
        if ($AgentId) {
            $path = "/inContactAPI/services/v20.0/agents/$AgentId"
        }
        else {
            $path = '/inContactAPI/services/v20.0/agents?'
            if ($PSBoundParameters.ContainsKey('IsActive')) {
                $path += "isActive=$IsActive&"
            }
            if ($SearchString) {
                $path += "searchString=$SearchString&"
            }
        }
        $uri = [uri]::new($url, $path)
        (Invoke-RestMethod -Uri $uri -Headers $headers).agents
    }
}