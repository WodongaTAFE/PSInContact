function Get-ICTeam {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName, ParameterSetName='id')]
        [int] $TeamId,

        [Parameter(ParameterSetName='notid')]
        [bool] $Active,

        [Parameter(ParameterSetName='notid')]
        [string] $SearchString
    )

    Begin {
        $url = $PsCmdlet.SessionState.PSVariable.GetValue("_ICUri")
        $token = $PsCmdlet.SessionState.PSVariable.GetValue("_ICToken")
        
        if (!$url -or !$token) {
            Throw "You must call the Connect-IC cmdlet before calling any other cmdlets."
        }

        Write-Verbose $url
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
            if ($Active) {
                $path += "isActive=$Active&"
            }
            if ($SearchString) {
                $path += "searchString=$SearchString&"
            }
        }
        $uri = [uri]::new($url, $path)

        (Invoke-RestMethod -Uri $uri -Headers $headers).teams
    }
}