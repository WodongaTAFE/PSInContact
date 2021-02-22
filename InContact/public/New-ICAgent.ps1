function New-IcAgent {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Username,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [securestring] $Password,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $EmailAddress,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $FirstName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $MiddleName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $LastName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $TeamId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
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
        $url = $Script:_IcUri
        $token = $Script:_IcToken
        
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
        # Extract plain text password from credential
        $marshal = [Runtime.InteropServices.Marshal]
        $pw = $marshal::PtrToStringAuto( $marshal::SecureStringToBSTR($Password) )

        $agent = @{
            userName = $Username
            password = $pw
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