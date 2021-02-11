function New-IcAgentSkill {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $AgentId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $SkillId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $Proficiency,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $Active = $true
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

        $skills = @()
    }

    Process {
        $skill = @{
            skillId = $SkillId
            isActive = $Active
        }

        if ($Proficiency) {
            $skill.proficiency = $Proficiency
        }

        $skills += $skill
    }

    End {
        $path = "/inContactAPI/services/v20.0/agents/$AgentId/skills"
        $uri = [uri]::new($url, $path)

        $body = @{
            skills = $skills
        }

        if ($PSCmdlet.ShouldProcess("Agent $AgentId", "Adding skill $SkillId")) {
            (Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json').skillResults
        }
    }
}