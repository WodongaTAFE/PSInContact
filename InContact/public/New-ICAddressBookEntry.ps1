function New-IcAddressBookEntry {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $AddressBookId,

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
        $url = $PsCmdlet.SessionState.PSVariable.GetValue("_ICUri")
        $token = $PsCmdlet.SessionState.PSVariable.GetValue("_ICToken")
        
        if (!$url -or !$token) {
            throw "You must call the Connect-IC cmdlet before calling any other cmdlets."
        }

        $headers = @{
            Authorization = "Bearer $token"
            Accept = 'application/json'
        }

        $entries = @()
    }

    Process {
        $entries += @{
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

        if ($PSCmdlet.ShouldProcess("Address book $AddressBookId", "Adding $($entries.Count) new entries")) {
            Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json'
        }
    }
}