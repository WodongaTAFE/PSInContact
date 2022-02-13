<#
.SYNOPSIS
    .Gets All (Active or not) Points of Contact on inContact CXOne
.DESCRIPTION
    .https://developer.niceincontact.com/API/AdminAPI#/General/getPointsOfContact
.PARAMETER mediaType
    String that is converted to an int.
    Acceptable values: email, chat, phone, voicemail, workitem, sms, social, digital

    
.EXAMPLE

    $phonePointsOfContact =  Get-ICPointOfContact -mediaType 'phone'

    $allPointsOfContact = Get-ICPointOfContact

.NOTES
    Author: Joe Gorsky  
#>

function Get-ICPointOfContact {
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [string] $mediaType,

        [Parameter()]
        [int]$pointOfContactId
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
            'DEFAULT' {$mediaTypeId = ''}
        }
        if($pointOfContactId){
            $path = "/inContactAPI/services/v23.0/points-of-contact/$pointOfContactId"
        }
        else{
            $path = "/inContactAPI/services/v23.0/points-of-contact?mediaTypeId=$mediaTypeId"
        }
        $uri = [uri]::new($url, $path)

        (Invoke-RestMethod -Uri $uri -Headers $headers).pointsOfContact
    }
}