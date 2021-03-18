function Get-ICTeam {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName, ParameterSetName='id')]
        [Alias('Id')]
        [string] $TeamId,

        [Parameter(ParameterSetName='notid')]
        [Alias('Active')]
        [bool] $IsActive,

        [Parameter(ParameterSetName='notid')]
        [Alias('Default')]
        [bool] $IsDefault
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
        if ($TeamId) {
            $path = "/user-management/v1/teams/$TeamId"
            $uri = [uri]::new($url, $path)
    
            (Invoke-RestMethod -Uri $uri -Headers $headers).team
            }
        else {
            $path = '/user-management/v1/teams/search'

            $filter = @{
            }

            if ($PSBoundParameters.ContainsKey('IsActive')) {
                $filter.status = @( if ($IsActive) { 'ACTIVE' } else { 'INACTIVE' } )
            }
            if ($PSBoundParameters.ContainsKey('IsDefault')) {
                $filter.isDefault = @( $IsDefault )
            }
            
            $body = @{
                filter = $filter
            }

            $uri = [uri]::new($url, $path)
    
            (Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -ContentType 'application/json' -Body (ConvertTo-Json $body) ).teams
        }
    }
}