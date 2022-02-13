function Get-ICRole {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName, ParameterSetName='id')]
        [Alias('Id')]
        [string] $RoleId,

        [Parameter(ParameterSetName='notid')]
        [Alias('Active')]
        [bool] $IsActive
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
        $path = '/authorization/v1/roles/search'

        $filter = @{
        }

        if ($RoleId) {
            $filter.roleId = @($RoleId)
        } elseif ($PSBoundParameters.ContainsKey('IsActive')) {
            $filter.status = @( if ($IsActive) { 'ACTIVE' } else { 'INACTIVE' } )
        }
        
        $body = @{
            filter = $filter
        }

        $uri = [uri]::new($url, $path)

        (Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -ContentType 'application/json' -Body (ConvertTo-Json $body) ).roles
    }
}