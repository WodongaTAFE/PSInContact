<#
.SYNOPSIS
Creates a new Hours of Operation for NICE-InContact. Open 24/7 with no holidays.

.DESCRIPTION
Creates a new Hours of Operation for NICE-InContact.  Open 24/7 with no holidays.



.PARAMETER profileName

Name of the profile that will appear in CXone

.


.EXAMPLE

    Connect-ic  (see "get-help connect-ic" for examples) to instantiate an authorization key
    New-ICHoursOfOperation -profileName "NewProfile" -description "test hours of operation"

This will create a new hours of operation open 24/7


#>
function New-ICHoursOfOperation {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string] $profileName,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [string] $description


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

            $path = '/inContactAPI/services/v23.0/hours-of-operation'
            $uri = [uri]::new($url, $path)
            $body = @{
                profileName = $profileName;
                description = $description
            }

            write-verbose "URI for HoursOfOperation REST Query: $uri"
            $hours = (Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json')
         
            Write-Verbose "new hours return: $hours"
            return $hours
        
    }
}