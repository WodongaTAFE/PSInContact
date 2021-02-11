<#
.SYNOPSIS
Connects to an inContact instance.

.DESCRIPTION
Call Connect-Ic to connect to an inContact instance (using its URL and credentials) before calling other inContact cmdlets.

.PARAMETER Uri
The base URI of the inContact instance domain.

.PARAMETER Credential
Specifies a PSCredential object. For more information about the PSCredential object, type Get-Help Get-Credential.

The PSCredential object provides the user ID and password for organizational ID credentials.

.EXAMPLE

Connect-Ic https://au1.nice-incontact.com -Credential (Get-Credential)

Prompts for your username and password, then connects to the au1 inContact instance.

.NOTES
See also: Disconnect-Ic.
#>
function Connect-IC {
    [CmdletBinding()]
    param (
        # The base URL of your Content Manager service API.
        [Parameter(Mandatory,Position=0)]
        [Alias('Url')]
        [uri]$Uri,

        # Secure login credentials for your Content Manager instance.
        [Parameter(Position=1)]
        [PSCredential] $Credential
    )

    if ($null -eq $Credential) {
        $Credential = Get-Credential
    }

    if ($Uri.OriginalString -notlike '*`/') {
        $Uri = [uri]::new($Uri.OriginalString + '/')
    }

    $path = '/.well-known/cxone-configuration'

    $endpoints  = Invoke-RestMethod -Uri ([uri]::new($Uri, $path))

    $PsCmdlet.SessionState.PSVariable.Set("_IcUri", [uri]::new($endpoints.api_endpoint))

    $authUri = [uri]::new($endpoints.auth_endpoint)

    # Extract plain text password from credential
    $marshal = [Runtime.InteropServices.Marshal]
    $password = $marshal::PtrToStringAuto( $marshal::SecureStringToBSTR($Credential.Password) )

    $path = [uri]::new('/authentication/v1/token/access-key', [UriKind]::Relative)
    $body = @{
        accessKeyId = $Credential.UserName
        accessKeySecret = $password
    } | ConvertTo-Json
 
    $result = Invoke-RestMethod -Method Post -Uri ([uri]::new($authUri, $path)) -Body $body -ContentType 'application/json'
    if ($result.access_token) {
        $PsCmdlet.SessionState.PSVariable.Set("_IcToken", $result.access_token)
    } else {
        throw "Could not connect to $Uri with the given credentials."
    }    
}