function Set-IcAgent {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string] $AgentId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $FirstName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $LastName,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)] #Mandatory in the API. Fails silently if not included (as of v23)
        [string] $TeamId,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)] #Mandatory in the API. Fails silently if not included (as of v23)
        [int] $SecurityProfileId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $EmailAddress,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Username,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $TimeZone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Country,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $State,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $City,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $UserType,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Active')]
        [bool] $IsActive = $true,

        [Parameter(ValueFromPipelineByPropertyName)]  #if not entered, auto generates one
        [securestring] $Password,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $MiddleName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $FederatedId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $ReportToId,

        [parameter(ValueFromPipelineByPropertyName)]
        [string] $internalId

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
        if($Password){
            $marshal = [Runtime.InteropServices.Marshal]
            $pw = $marshal::PtrToStringAuto( $marshal::SecureStringToBSTR($Password) )
        }
        $agent = @{
            middleName = $MiddleName
            lastName = $LastName
            reportToId = $ReportToId
            federatedId = $FederatedId
            internalId = $internalId
            userName = $Username
            password = $pw
            emailAddress = $EmailAddress
            firstName = $FirstName
            teamId = $TeamId
            timeZone = $TimeZone
            country = $Country
            state = $State
            city = $City
            isActive = $IsActive
            userType = $UserType
            agentId = $AgentId
        }

        # strip out all the properties that weren't provided as parameters
        #for some reason this strips out profileId even when entered. Moving "Mandatory" fields to be appended after the fact. 
        $k = @($agent.Keys)
        $k | ForEach-Object {
            if (-not $PSBoundParameters.ContainsKey($_)) {
                $agent.Remove($_)
            }
        }

        if($null -ne $SecurityProfileId){
            $agent += @{
                profileId = [int]$SecurityProfileId #Casting to int. Even though input is [int] it sends as a string for some reason. Also gets removed from the parser above.
            }
        }

        $agents += $agent



    }

    End {

        if($null -eq $FederatedId){  $path = "/inContactAPI/services/v23.0/agents/" }
        else{ $path = "/inContactAPI/services/v19.0/agents" }#for whatever reason, v19 of the API updates the federated ID field without issue where v20->23 fail to update the field
        $uri = [uri]::new($url, $path)
        $body = @{
            agents = $agents
        }

        if ($PSCmdlet.ShouldProcess("Agent", "Updating agent")) {
            (Invoke-RestMethod -Method Put -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json')
        }
    }
}