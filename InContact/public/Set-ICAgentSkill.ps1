function Set-IcAgentSkill {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $AgentId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $SkillId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $Proficiency,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $Active
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
        }
        
        if ($PSBoundParameters.ContainsKey('active')) {
            Write-Verbose "Active was $Active"
            $skill.isActive = $Active
        }

        if ($Proficiency) {
            Write-Verbose 'Proficiency was specified!'
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

        if ($PSCmdlet.ShouldProcess("Agent $AgentId", "Updating skill $SkillId")) {
            Invoke-RestMethod -Method Put -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json'
        }
    }
}