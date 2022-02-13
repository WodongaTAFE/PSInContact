<#
.SYNOPSIS
Fetches Details for Hours of Operation(s) for NICE-InContact

.DESCRIPTION
Fetches details for Hours of Operations on NICE-InContact


.PARAMETER HoursOfOpID
Primary Key ID for a specific Hours of Operation you want to get details of.

.EXAMPLE

    Connect-ic  (see get-help | connect-ic for examples) to instantiate an authorization key
    Get-ICHoursOfOperation

This will fetch all the hours of operation for your business unit

.EXAMPLE

   Connect-ic  (see get-help | connect-ic for examples) to instantiate an authorization key

   Get-ICHoursOfOperation -HoursOfOpID 999

This will fetch details for hours of operation ID 999

#>
function Get-ICHoursOfOperation {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        [int] $HoursOfOpID
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

        if($HoursOfOpID){
            $path = '/inContactAPI/services/v23.0/hours-of-operation/' + $HoursOfOpID
            $uri = [uri]::new($url, $path)

        }
        else{
            $path = '/inContactAPI/services/v23.0/hours-of-operation'
            $uri = [uri]::new($url, $path)

        }
            write-verbose "URI for HoursOfOperation REST Query: $uri"
            $getHours = (Invoke-RestMethod -Uri $uri -Headers $headers)
            $hoursProfiles = $getHours.resultSet.hoursOfOperationProfiles

            return $hoursProfiles
        
    }
}