<#
.SYNOPSIS
Creates a new Skill on NICE-InContact
.DESCRIPTION
Creates a new Skill on NICE-inContact. Does not assign to agents (do that in a separate step)





.EXAMPLE

    Connect-ic  (see "get-help connect-ic" for examples) to instantiate an authorization key



#>

function New-ICSkill {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$mediaType,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$skillName,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]$campaignId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$isOutbound,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$outboundStrategy,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$callerIdOverride,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$emailFromAddress,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$emailFromEditable,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$emailBccAddress,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$scriptId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$reskillHours,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$minWfiAgents,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$minWfiAvailableAgents,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$interruptible,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$enableParking,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$minWorkingTime,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$agentless,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$agentlessPorts,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$notes,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$acwTypeId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$requireDisposition,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$allowSecondaryDisposition,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$stateIdAcw,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$maxSecondsAcw,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$agentRestTime,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$displayThankYou,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$thankYouLink,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$popThankYou,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$popThankYouUrl,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$makeTranscriptAvailable,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$transcriptFromAddress,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$priorityBlending,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$callSuppressionScriptId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$useScreenPops,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$screenPopTriggerEvent,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$useCustomScreenPops,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$screenPopType,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$screenPopDetails,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$initialPriority,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$acceleration,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$maxPriority,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$serviceLevelThreshold=30,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$serviceLevelGoal=90,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$enableShortAbandon=$false,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$shortAbandonThreshold=15,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$countShortAbandons,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$countOtherAbandons,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$chatWarningThreshold,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$agentTypingIndicator,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$patronTypingIndicator,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$smsTransportCodeId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$messageTemplateId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [array]$dispositions,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$deliverMultipleNumbersSerially,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$cradleToGrave,
        [Parameter(ValueFromPipelineByPropertyName)]
        [bool]$priorityInterrupt,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$outboundTelecomRouteId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]$acwPostTimeoutState,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$workItemQueueType
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

        $skills = @()
    }

    Process {
        switch($mediaType.ToUpper()){
            'EMAIL' {$mediaTypeId = 1}
            'CHAT' {$mediaTypeId = 3}
            'PHONE' {$mediaTypeId = 4}
            'VOICEMAIL' {$mediaTypeId = 5}
            'WORKITEM' {$mediaTypeId = 6}
            'SMS' {$mediaTypeId = 7}
            'SOCIAL' {$mediaTypeId = 8}
            'DIGITAL' {$mediaTypeId = 9}
            'DEFAULT' {Write-Error -message "Invalid Media Type - Please try again with one of the following: 'phone', 'chat', 'email', 'voicemail', 'sms', 'social', 'digital'" -Category InvalidData}
        }

        write-verbose "Media Type ID: $mediatypeId"

        $skill = @{
            isOutbound = $isOutbound
            outboundStrategy = $outboundStrategy
            callerIdOverride = $callerIdOverride
            emailFromAddress = $emailFromAddress
            emailFromEditable = $emailFromEditable
            emailBccAddress = $emailBccAddress
            scriptId = $scriptId
            reskillHours = $reskillHours
            minWfiAgents = $minWfiAgents
            minWfiAvailableAgents = $minWfiAvailableAgents
            interruptible = $interruptible
            enableParking = $enableParking
            minWorkingTime = $minWorkingTime
            agentless = $agentless
            agentlessPorts = $agentlessPorts
            notes = $notes
            acwTypeId = $acwTypeId
            requireDisposition = $requireDisposition
            allowSecondaryDisposition = $allowSecondaryDisposition
            stateIdAcw = $stateIdAcw
            maxSecondsAcw = $maxSecondsAcw
            agentRestTime = $agentRestTime
            displayThankYou = $displayThankYou
            thankYouLink = $thankYouLink
            popThankYou = $popThankYou
            popThankYouUrl = $popThankYouUrl
            makeTranscriptAvailable = $makeTranscriptAvailable
            transcriptFromAddress = $transcriptFromAddress
            priorityBlending = $priorityBlending
            callSuppressionScriptId = $callSuppressionScriptId
            useScreenPops = $useScreenPops
            screenPopTriggerEvent = $screenPopTriggerEvent
            useCustomScreenPops = $useCustomScreenPops
            screenPopType = $screenPopType
            screenPopDetails = $screenPopDetails
            initialPriority = $initialPriority
            acceleration = $acceleration
            maxPriority = $maxPriority
            countShortAbandons = $countShortAbandons
            countOtherAbandons = $countOtherAbandons
            chatWarningThreshold = $chatWarningThreshold
            agentTypingIndicator = $agentTypingIndicator
            patronTypingIndicator = $patronTypingIndicator
            smsTransportCodeId = $smsTransportCodeId
            messageTemplateId = $messageTemplateId
            dispositions = $dispositions
            deliverMultipleNumbersSerially = $deliverMultipleNumbersSerially
            cradleToGrave = $cradleToGrave
            priorityInterrupt = $priorityInterrupt
            outboundTelecomRouteId = $outboundTelecomRouteId
            acwPostTimeoutState = $acwPostTimeoutState
            workItemQueueType = $workItemQueueType
        }

        # strip out all the properties that weren't provided as parameters
        #for some reason this strips out profileId even when entered. Moving "Mandatory" fields to be appended after the fact. 
        $k = @($skill.Keys)
        $k | ForEach-Object {
            if (-not $PSBoundParameters.ContainsKey($_)) {
                $skill.Remove($_)
            }
        }
        $skill += @{ #Mandatory Parameters
            mediaTypeId = $mediaTypeId
            skillName = $skillName
            campaignId = $campaignId
            serviceLevelThreshold = $serviceLevelThreshold
            serviceLevelGoal = $serviceLevelGoal
            enableShortAbandon = $enableShortAbandon
            shortAbandonThreshold = $shortAbandonThreshold

        }


        $skills += $skill
    }

    End {
        $path = '/inContactAPI/services/v22.0/skills' #issues with V23 of the API. Disconnects with no return. V22 works just fine.
        $uri = [uri]::new($url, $path)

        $body = @{
            skills = $skills
        }

        if ($PSCmdlet.ShouldProcess("Skills", "Adding $($skills.Count) skills")) {
            (Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json')        

        }
    }
}