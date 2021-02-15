
function Get-ICAgentSkill {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $AgentId,

        [Alias('SearchText')]
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
        if ($AgentId) {
            $path = "/inContactAPI/services/v20.0/agents/$AgentId/skills?"
        }
        else {
            $path = "/inContactAPI/services/v20.0/agents/skills?"
        }
        if ($SearchString) {
            $path += "searchString=$SearchString&"
        }
        $uri = [uri]::new($url, $path)

        (Invoke-RestMethod -Uri $uri -Headers $headers).agentSkillAssignments
    }
}