function Get-ICProfile {
    [CmdletBinding(DefaultParameterSetName='notid')]
    param (
        [Parameter(Mandatory, Position=0, ParameterSetName='id')]
        [Alias('id')]
        [string] $ProfileId,

        [Parameter(ParameterSetName='notid')]
        [Alias('Active')]
        [bool] $IsActive
    )

    begin {
        $url = $PsCmdlet.SessionState.PSVariable.GetValue("_ICUri")
        $token = $PsCmdlet.SessionState.PSVariable.GetValue("_ICToken")
        
        if (!$url -or !$token) {
            throw "You must call the Connect-IC cmdlet before calling any other cmdlets."
        }
    
        $headers = @{
            Authorization = "Bearer $token"
            Accept = 'application/json'
        }
    }

    process {
        if ($ProfileId) {
            $path = "/inContactAPI/services/v20.0/workflow-data/$ProfileId"
        }
        else {
            $path = '/inContactAPI/services/v20.0/workflow-data/list/'
            if ($PSBoundParameters.ContainsKey('IsActive')) {
                $path += if ($IsActive) { '1' } else { '2' }
            }
            else {
                $path += '0'
            }
        }
        $uri = [uri]::new($url, $path)
        (Invoke-RestMethod -Uri $uri -Headers $headers)
    }
}
