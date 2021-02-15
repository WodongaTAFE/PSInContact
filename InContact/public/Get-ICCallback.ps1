function Get-ICCallback {
    [CmdletBinding(DefaultParameterSetName='agent')]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName, ParameterSetName='agent')]
        [string] $AgentId,

        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName, ParameterSetName='skill')]
        [string] $SkillId
    )

    begin {
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

    process {
        if ($SkillId) {
            $path = "/inContactAPI/services/v20.0/skills/$SkillId/scheduled-callbacks"
        }
        else {
            $path = "/inContactAPI/services/v20.0/agents/$AgentId/scheduled-callbacks"
        }
        $uri = [uri]::new($url, $path)
        (Invoke-RestMethod -Uri $uri -Headers $headers)
    }
}
