function Set-IcSkill{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $SkillId,

        [Parameter(ValueFromPipelineByPropertyName)] 
        [String]$skillName, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [int]$campaignId, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [String]$callerIdOverride, 
        
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
        [string]$notes, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [int]$acwTypeId, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [bool]$requireDisposition, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [bool]$scriptDisposition, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [int]$stateIdAcw, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [int]$maxSecondsAcw, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [int]$agentRestTime, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [bool]$displayThankYou, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [bool]$thankYouLink, 
        
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
        [int]$serviceLevelThreshold, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [int]$serviceLevelGoal, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [bool]$enableShortAbandon, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [int]$shortAbandonThreshold, 
        
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
        [bool]$deliverMultipleNumbersSerially, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [bool]$cradleToGrave, 
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [bool]$priorityInterrupt, 

        #dispostion ##NOT HANDLED
        
        [Parameter(ValueFromPipelineByPropertyName)] 
        [int]$acwPostTimeoutStateId

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
        $skill = @{
            skillName = $skillName
            campaignId = $campaignId
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
            notes = $notes
            acwTypeId = $acwTypeId
            requireDisposition = $requireDisposition
            allowSecondaryDisposition = $allowSecondaryDisposition
            scriptDisposition = $scriptDisposition
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
            serviceLevelThreshold = $serviceLevelThreshold
            serviceLevelGoal = $serviceLevelGoal
            enableShortAbandon = $enableShortAbandon
            shortAbandonThreshold = $shortAbandonThreshold
            countShortAbandons = $countShortAbandons
            countOtherAbandons = $countOtherAbandons
            chatWarningThreshold = $chatWarningThreshold
            agentTypingIndicator = $agentTypingIndicator
            patronTypingIndicator = $patronTypingIndicator
            smsTransportCodeId = $smsTransportCodeId
            messageTemplateId = $messageTemplateId
            deliverMultipleNumbersSerially = $deliverMultipleNumbersSerially
            cradleToGrave = $cradleToGrave
            priorityInterrupt = $priorityInterrupt
            acwPostTimeoutStateId = $acwPostTimeoutStateId
        }
        
        # strip out all the properties that weren't provided as parameters
        $k = @($skill.Keys)
        $k | ForEach-Object {
            if (-not $PSBoundParameters.ContainsKey($_)) {
                write-verbose "stripping key $_"
                $skill.Remove($_)
            }
        }
        
    }

    End {
        $path = "/inContactAPI/services/v23.0/skills/$skillId"
        $uri = [uri]::new($url, $path)

        $body = @{
            skill = $skill
        }

        

        if ($PSCmdlet.ShouldProcess("Updating skill $SkillId")) {
            Invoke-RestMethod -Method Put -Uri $uri -Headers $headers -Body (ConvertTo-Json $body) -ContentType 'application/json'
        }
    }
}