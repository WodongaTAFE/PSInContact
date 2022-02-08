function Remove-IcAgentSkill {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $AgentId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $SkillId
    )

    Begin {
        $url = $Script:_IcUri
        $token = $Script:_IcToken
        
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
        $skills += @{
            skillId = $SkillId
        }
    }

    End {
        $path = "/inContactAPI/services/v20.0/agents/$AgentId/skills"
        $uri = [uri]::new($url, $path)

        $body = @{
            skills = $skills
        }

        if ($PSCmdlet.ShouldProcess("Agent $AgentId", "Removing skill $SkillId")) {
            Invoke-RestMethod -Method Delete -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json'
        }
    }
}