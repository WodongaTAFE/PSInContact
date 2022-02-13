function Remove-ICContact {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $ContactID

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
        $path = "/inContactAPI/services/v23.0/contacts/$contactId/end"
        $uri = [uri]::new($url, $path)

        if ($PSCmdlet.ShouldProcess("Attempting to terminate Contact ID", "Removing entry $ContactID")) {
            Invoke-RestMethod -Method Post -Uri $uri -Headers $headers
        }
    }
}