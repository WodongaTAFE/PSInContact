<#
.SYNOPSIS
    .Creates (Active or not) Points of Contact on inContact CXOne
.DESCRIPTION
    .https://developer.niceincontact.com/API/AdminAPI#/General/getPointsOfContact
.PARAMETER mediaType
    .String that is converted to an int.
    .Acceptable values: email, chat, phone, voicemail, workitem, sms, social, digital
.EXAMPLE
    New-ICPointOfContact -scriptName $scriptName -skillId $skillId -mediaType 'phone' -pointOfContactName $pocName -pointOfContact $pocPhoneNumber

.NOTES
    .Author: Joe Gorsky  
#>

function Set-ICPointOfContact {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Position=0,Mandatory)]
        [int] $pointOfContactId,

        [Parameter(mandatory,ValueFromPipelineByPropertyName)]
        [String]$pointOfContactName,

        [parameter(mandatory, ValueFromPipelineByPropertyName)]
        [int]$skillId,

        [Parameter(mandatory,ValueFromPipelineByPropertyName)]
        [string]$scriptName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $IVRReportingEnabled = $true,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Active')]
        [bool] $IsActive = $true,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$chatProfileId = $null,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $notes
    )


    Begin {
        $url = $Script:_IcUri
        $token = $Script:_IcToken
        
        if (!$url -or !$token) {
            throw "You must call the Connect-IC cmdlet before calling any other cmdlets."
        }

        $headers = @{
            Authorization = "Bearer $token"
            Accept = 'application/json'
        }
    }

    Process {
        $pointOfContactObj = @{
            pointOfContactName = $pointOfContactName
            skillId = $skillId
            isActive = $IsActive
            scriptName = $scriptName
            ivrReportingEnabled = $IVRReportingEnabled
        }

        if($chatProfileId -eq 0){
            write-verbose "Chat Profile ID is 0 (null)"
            $pointOfContactObj += @{
                 chatProfileId = $null
            }
        }
        else{
            $pointOfContactObj += @{
                chatProfileId = $chatProfileId
           }
         }
        
        

        Write-Verbose ($pointOfContactObj | Out-String)

        $path = "/inContactAPI/services/v23.0/points-of-contact/$pointOfContactId"

        $uri = [uri]::new($url, $path)
        if ($PSCmdlet.ShouldProcess($pointOfContactId, "Updating New Point of Contact")) {
            (Invoke-RestMethod -method PUT -Uri $uri -Headers $headers -Body (ConvertTo-Json $pointOfContactObj) -ContentType 'application/json').pointsOfContact
        }
    }
}