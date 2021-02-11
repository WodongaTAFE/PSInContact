
function Get-ICTeamAgent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $TeamId,

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
        $path = "/inContactAPI/services/v20.0/teams/$TeamId/agents?"
        if ($SearchString) {
            $path += "searchString=$SearchString&"
        }
        $uri = [uri]::new($url, $path)

        (Invoke-RestMethod -Uri $uri -Headers $headers).teams.agents
    }
}