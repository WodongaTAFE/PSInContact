<#
.SYNOPSIS
Creates a new agent on NICE-InContact
.DESCRIPTION
Creates a new agent on NICE-inContact. Does not assign skills (do that in a separate step)





.EXAMPLE

    Connect-ic  (see "get-help connect-ic" for examples) to instantiate an authorization key
    New-ICAgent  -username "abc@domain.xyz" -emailAddress "abc@domain.xyz" -firstname "abc" -lastname "fakename" -teamId 12345 -SecurityProfileId 112 -timezone "(GMT-05:00) Eastern Time (US & Canada)" -userType "Admin" -country "US" -state "MI" -city "Detroit"


Creates a new agent. Sends them a system-generated password.


#>

function New-ICAgent {
    [CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $FirstName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $LastName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $TeamId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $SecurityProfileId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $EmailAddress,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Username,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $TimeZone,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Country,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $State,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string] $City,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
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
        }

        # strip out all the properties that weren't provided as parameters
        #for some reason this strips out profileId even when entered. Moving "Mandatory" fields to be appended after the fact. 
        $k = @($agent.Keys)
        $k | ForEach-Object {
            if (-not $PSBoundParameters.ContainsKey($_)) {
                $agent.Remove($_)
            }
        }
        $agent += @{ #Mandatory Parameters
            userName = $Username
            password = $pw
            emailAddress = $EmailAddress
            firstName = $FirstName
            teamId = $TeamId
            profileId = [int]$SecurityProfileId #Casting to int. Even though input is [int] it sends as a string for some reason.
            timeZone = $TimeZone
            country = $Country
            state = $State
            city = $City
            isActive = $IsActive
            userType = $UserType

        }


        $agents += $agent
    }

    End {
        if($null -eq $FederatedId){  $path = "/inContactAPI/services/v23.0/agents" }
        else{ $path = "/inContactAPI/services/v23.0/agents" }#for whatever reason, v19 of the API updates the federated ID field without issue where v20->23 fail to update the field
        $uri = [uri]::new($url, $path)

        $body = @{
            agents = $agents
        }

        if ($PSCmdlet.ShouldProcess("Agents", "Adding $($agents.Count) agents")) {
            try{
            (Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json')        
        } catch{
            Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
            Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
        }
        }
    }
}