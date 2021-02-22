function Set-ICAddressBookEntry {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $AddressBookId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $AddressBookEntryId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $FirstName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $MiddleName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $LastName,

        [Parameter( ValueFromPipelineByPropertyName)]
        [string] $Company,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Phone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Mobile,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Email
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

        $entries = @()
    }

    Process {
        $entries += @{
            addressBookEntryId = $AddressBookEntryId
            firstName  = $FirstName
            middleName = $MiddleName
            lastName = $LastName
            company = $Company
            phone = $Phone
            mobile = $Mobile
            email = $Email
        }
    }
    End {
        $path = "/inContactAPI/services/v20.0/address-books/$AddressBookId/entries"
        $uri = [uri]::new($url, $path)

        $body = @{
            addressBookEntries = $entries
        }

        if ($PSCmdlet.ShouldProcess("Address book $AddressBookId", "Modifying $($entries.Count) new entries")) {
            Invoke-RestMethod -Method Put -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json'
        }
    }
}