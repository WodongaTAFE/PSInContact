function Set-IcUser {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string] $UserId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $FirstName,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $LastName,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $EmailAddress,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $MobileNumber,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $AssignedGroup,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $Rank,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Country,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $TimeZone,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Role,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $TeamId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [nullable[datetime]] $HireDate,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Username,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $ExternalIdentity 
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
    }

    Process {
        $user = @{
            firstName = $FirstName
            lastName = $LastName
            emailAddress = $EmailAddress
            assignedGroup = $AssignedGroup
            rank = $Rank
            country = $Country
            timeZone = $TimeZone
            role = $Role
            teamId = $TeamId
            userName = $Username
            externalIdentity = $ExternalIdentity
        }

        # strip out all the properties that weren't provided as parameters
        $k = @($user.Keys)
        $k | ForEach-Object {
            if (-not $PSBoundParameters.ContainsKey($_)) {
                $user.Remove($_)
            }
        }

        $user.id = $UserId

        if ($HireDate) {
            $user.hireDate = $HireDate.ToString('o')
        }
        if ($MobileNumber) {
            $user.mobileNumber = $MobileNumber
        }

        $path = "/user-management/v1/users"
        $uri = [uri]::new($url, $path)

        ConvertTo-Json $user
        if ($PSCmdlet.ShouldProcess($Username, "Updating user")) {
            Invoke-RestMethod -Method Put -Uri $uri -Headers $headers -Body (ConvertTo-Json $user) -ContentType 'application/json' 
        }
     }
}