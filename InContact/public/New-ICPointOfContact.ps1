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

function New-ICPointOfContact {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Position=0,Mandatory)]
        [string] $mediaType,

        [Parameter(Mandatory)]
        [string] $pointOfContact,

        [Parameter(Mandatory)]
        [String]$pointOfContactName,

        [parameter(Mandatory)]
        [int]$skillId,

        [Parameter(Mandatory)]
        [string]$scriptName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [bool] $IVRReportingEnabled = $true,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Active')]
        [bool] $IsActive = $true,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int] $chatProfileId 
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
        switch($mediaType.ToUpper()){
            'EMAIL' {$mediaTypeId = 1}
            'CHAT' {$mediaTypeId = 3}
            'PHONE' {$mediaTypeId = 4}
            'VOICEMAIL' {$mediaTypeId = 5}
            'WORKITEM' {$mediaTypeId = 6}
            'SMS' {$mediaTypeId = 7}
            'SOCIAL' {$mediaTypeId = 8}
            'DIGITAL' {$mediaTypeId = 9}
            'DEFAULT' {Write-Error -message "Invalid Media Type - Please try again with one of the following: 'phone', 'chat', 'email', 'voicemail', 'sms', 'social', 'digital'" -Category InvalidData}
        }


        $pointOfContactObj = @{
            pointOfContact = $pointOfContact
            pointOfContactName = $pointOfContactName
            skillId = $skillId
            isActive = $IsActive
            mediaTypeId = $mediaTypeId
            scriptName = $scriptName
            ivrReportingEnabled = $IVRReportingEnabled
        }
        
        if($mediaTypeId -eq 3){ #only required for chats, normal key removal method is stripping other required parameters
            $pointOfContactObj += @{
                chatProfileId = $chatProfileId
            }
        }

        $path = "/inContactAPI/services/v23.0/points-of-contact"

        $uri = [uri]::new($url, $path)
        if ($PSCmdlet.ShouldProcess($pointOfContact, "Adding New Point of Contact")) {
            (Invoke-RestMethod -method POST -Uri $uri -Headers $headers -Body (ConvertTo-Json $pointOfContactObj) -ContentType 'application/json').pointsOfContact
        }
    }
}