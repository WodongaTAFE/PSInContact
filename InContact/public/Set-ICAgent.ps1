function Set-IcAgent {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string] $AgentId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $TeamId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Username,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $EmailAddress,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $FirstName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $MiddleName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $LastName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $ProfileId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $ReportToId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $TimeZone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Country,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $State,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $City,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Active')]
        [bool] $IsActive = $true
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

        $agents = @()
    }

    Process {
        $agent = @{
            agentId = $AgentId
            userName = $Username
            emailAddress = $EmailAddress
            firstName = $FirstName
            middleName = $MiddleName
            lastName = $LastName
            teamId = $TeamId
            profileId = $ProfileId
            timeZone = $TimeZone
            country = $Country
            state = $State
            city = $City
            reportToId = $ReportToId
            isActive = $IsActive
        }

        # strip out all the properties that weren't provided as parameters
        $k = @($agent.Keys)
        $k | ForEach-Object {
            if (-not $PSBoundParameters.ContainsKey($_)) {
                $agent.Remove($_)
            }
        }

        $agents += $agent
    }

    End {
        $path = '/inContactAPI/services/v20.0/agents'
        $uri = [uri]::new($url, $path)

        $body = @{
            agents = $agents
        }

        if ($PSCmdlet.ShouldProcess("Agents", "Adding $($agents.Count) agents")) {
            (Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json').agentResults
        }
    }
}