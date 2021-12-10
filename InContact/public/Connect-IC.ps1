<#
.SYNOPSIS
Fetches an access token for the inContact REST API

.DESCRIPTION
Call Connect-Ic to connect to an inContact instance before calling other inContact cmdlets. 

Stores key as script scoped var $Script:_IcToken

-For UserHub-
You will use an access token and use the appropriate URI for your geographic location
Identify your URI and instruction on how to generate an access token: https://developer.niceincontact.com/Documentation/UserHubGettingStarted

-For Central (Legacy Instance)-
You will connect via OAUTH2. Use flag -Central parameter to connect
Getting Started docs: https://developer.niceincontact.com/Documentation/GettingStarted


.PARAMETER Uri
The base URI of the inContact instance domain for Userhub instances

.PARAMETER Credential
Specifies a PSCredential object. For more information about the PSCredential object, type Get-Help Get-Credential.

The PSCredential object provides the user ID and password for organizational ID credentials.

For Userhub, this is your access key and access key secret pair.

For Central, this is your central admin login.

.PARAMETER Central
Indicates you are connecting to a business unit that utilizes Central

.PARAMETER Key
BASE64 encoded string used for the OAUTH2 token retrevial in Central. 

Specifically, base64 encoding of AppName@VendorName:BusinessUnitNumber
API Application Generation Link: https://help.incontact.com/Content/ACD/APIApplications/APIApplications.htm

.EXAMPLE

Connect-Ic https://au1.nice-incontact.com -Credential (Get-Credential)

Prompts for your username and password, then connects to the au1 inContact instance of Userhub

.EXAMPLE

Connect-Ic -Central -Credential (Get-Credential) -Key "QXBwTmFtZUBWZW5kb3JOYW1lOkJ1c2luZXNzVW5pdE51bWJlcg=="


.NOTES
See also: Disconnect-Ic.
#>
function Connect-IC {
    [CmdletBinding(DefaultParameterSetName='UserHub')]
    param (
        # The base URL of your Content Manager service API.
        [Parameter(Position=0,ParameterSetName='UserHub',Mandatory=$true)]
        [Alias('Url')]
        [uri]$Uri,

        # Secure login credentials for your Content Manager instance.
        [Parameter(Position=1)]
        [PSCredential] $Credential,

        [Parameter(ParameterSetName='Central',Position=2,Mandatory=$false)]
        [switch] $Central,

        [Parameter(ParameterSetName='Central',Mandatory=$true)]
        [string] $Key


    )

    #we use credential for both userhub and central
    #for central, it's the Admin User's UN and PWD. Same login as logging in via login.incontact.com
    #for userhub, it's the access key and access key pwd pairing as is generated on the end user.
    if ($null -eq $Credential) {
        $Credential = Get-Credential
    }


    # Extract plain text password from credential
    $marshal = [Runtime.InteropServices.Marshal]
    $password = $marshal::PtrToStringAuto( $marshal::SecureStringToBSTR($Credential.Password) )
    

    write-host $Credential.UserName



    if($Central){ #CENTRAL AUTH
        $Uri = "https://api.incontact.com/InContactAuthorizationServer/Token"
 
    
        $Body = @{'grant_type' = "password";} 
        $Body += @{'username'   = $Credential.UserName;}
        $Body += @{'password'   = "$Password";}
        $Body += @{'scope'      = "$Scope"}
    
        $JsonBody = ConvertTo-Json $Body
    
        $Header = @{
            'Authorization' = "basic $Key";
            'Content-Type'  = 'application/json';
        }
    
        $result = Invoke-RestMethod -Method POST -Uri $Uri -Body $JsonBody -Headers $Header
    
        if ($result.access_token) {
            $Script:_IcToken = $result.access_token
            $Script:_IcUri=[uri]::new($result.resource_server_base_uri)
            Write-Verbose $Script:_IcUri
            Write-Verbose $Script:_IcToken
        } else {
            throw "Could not fetch access token for Central with the given credentials."
        } 

    }
    else{ #USERHUB AUTH

       
    
        if ($Uri.OriginalString -notlike '*`/') {
            $Uri = [uri]::new($Uri.OriginalString + '/')
        }
    
        #userhub path
        $path = '/.well-known/cxone-configuration'

        $endpoints  = Invoke-RestMethod -Uri ([uri]::new($Uri, $path))

        $Script:_IcUri = [uri]::new($endpoints.api_endpoint)

        $authUri = [uri]::new($endpoints.auth_endpoint)



        $path = [uri]::new('/authentication/v1/token/access-key', [UriKind]::Relative)
        $body = @{
            accessKeyId = $Credential.UserName
            accessKeySecret = $password
        } | ConvertTo-Json
    
        $result = Invoke-RestMethod -Method Post -Uri ([uri]::new($authUri, $path)) -Body $body -ContentType 'application/json'
        if ($result.access_token) {
            $Script:_IcToken = $result.access_token
            Write-Verbose $Script:_IcUri
            Write-Verbose $Script:_IcToken
        } else {
            throw "Could not connect to $Uri with the given credentials."
        }   
    }    
}
