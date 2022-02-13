<#
.SYNOPSIS
Changes Hours of Operation for NICE-InContact. Days as 

.DESCRIPTION
Updates an Hours of Operation for NICE-InContact.

If a day is omitted: leaves existing hours for the day in place. 

EG: if we are sunday-saturday 24/7, and we push $days = '[    
    {
      "day": "Tuesday",
      "isClosedAllDay": true
    }
  ]'

the hours will turn into All days except tuesday: 24/7. Tuesday: closed.





.PARAMETER profileId
Primary Key ID of the profile that will appear in CXone

.PARAMETER days
Array that includes hours of all days. 

Syntax:
$days = [
    {
      "day": "Sunday",
      "isClosedAllDay": true
    },
    {
      "day": "Monday",
      "openTime": "08:00:00",
      "closeTime": "17:00:00",
      "hasAdditionalHours": false,
      "isClosedAllDay": false
    },
    {
      "day": "Tuesday",
      "openTime": "08:00:00",
      "closeTime": "17:00:00",
      "hasAdditionalHours": false,
      "isClosedAllDay": false
    },
    {
      "day": "Wednesday",
      "openTime": "08:00:00",
      "closeTime": "17:00:00",
      "hasAdditionalHours": false,
      "isClosedAllDay": false
    },
    {
      "day": "Thursday",
      "openTime": "08:00:00",
      "closeTime": "17:00:00",
      "hasAdditionalHours": false,
      "isClosedAllDay": false
    },
    {
      "day": "Friday",
      "openTime": "08:00:00",
      "closeTime": "17:00:00",
      "hasAdditionalHours": false,
      "isClosedAllDay": false
    },
    {
      "day": "Saturday",
      "isClosedAllDay": true
    }
  ]


.EXAMPLE

$daysJSON = '[    {
      "day": "Sunday",
      "isClosedAllDay": true
    },
    {
      "day": "Monday",
      "isClosedAllDay": true
    },
    {
      "day": "Tuesday",
      "openTime": "08:00:00",
      "closeTime": "17:00:00",
      "hasAdditionalHours": false,
      "isClosedAllDay": false
    },
    {
      "day": "Wednesday",
      "openTime": "08:00:00",
      "closeTime": "17:00:00",
      "hasAdditionalHours": false,
      "isClosedAllDay": false
    },
    {
      "day": "Thursday",
      "openTime": "08:00:00",
      "closeTime": "17:00:00",
      "hasAdditionalHours": false,
      "isClosedAllDay": false
    },
    {
      "day": "Friday",
      "openTime": "08:00:00",
      "closeTime": "17:00:00",
      "hasAdditionalHours": false,
      "isClosedAllDay": false
    },
    {
      "day": "Saturday",
      "isClosedAllDay": true
    }
  ]'



$days = ConvertFrom-Json -InputObject $daysJSON
$holidays = ConvertFrom-JSON -inputObject $holidaysJSON

    Connect-ic  (see "get-help connect-ic" for examples) to instantiate an authorization key
    Set-ICHoursOfOperation -profileId 1111 -days $days -holidays $holidays



#>
function Set-ICHoursOfOperation {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [Alias('id')]
        [string] $hoursOfOpID,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [array] $days


        #testing pushing holidays breaks the hours of operation in an unrecoverable way at this time.
       # [Parameter(ValueFromPipelineByPropertyName)]
        #[array] $holidays
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

            $path = '/inContactAPI/services/v23.0/hours-of-operation/'+$profileId
            $uri = [uri]::new($url, $path)
            $body = @{
                days = $days;
                holidays = $holidays
            }

            write-verbose "URI for HoursOfOperation REST Query: $uri"
            try{
                $hours = (Invoke-RestMethod -Method PUT -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json')
                Write-Verbose "new hours return: $hours"
                return $hours
            } catch{
                Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
                Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
            }
            
        
    }
  }