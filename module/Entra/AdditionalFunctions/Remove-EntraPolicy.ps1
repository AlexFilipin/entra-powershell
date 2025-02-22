# ------------------------------------------------------------------------------
#  Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
# ------------------------------------------------------------------------------
function Remove-EntraPolicy {
    [CmdletBinding(DefaultParameterSetName = '')]
    param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [System.String] $Id
    )

    PROCESS {    
        $params = @{}
        $customHeaders = New-EntraCustomHeaders -Command $MyInvocation.MyCommand
        $policyTypes = "activityBasedTimeoutPolicies", "defaultAppManagementPolicy", "appManagementPolicies", "authenticationFlowsPolicy", "authenticationMethodsPolicy", "claimsMappingPolicies", "featureRolloutPolicies", "homeRealmDiscoveryPolicies", "permissionGrantPolicies", "tokenIssuancePolicies", "tokenLifetimePolicies"
    
        foreach ($policyType in $policyTypes) {
            $uri = "https://graph.microsoft.com/v1.0/policies/" + $policyType + "/" + $id
            try {
                $response = Invoke-GraphRequest -Headers $customHeaders -Uri $uri -Method GET
                break
            }
            catch {}
        }
        $policy = ($response.'@odata.context') -match 'policies/([^/]+)/\$entity'
    
        $policyType = $Matches[1]

        Write-Debug("============================ Matches ============================")

        Write-Debug($Matches[1])

        if (($null -ne $PSBoundParameters["id"]) -and ($null -ne $policyType )) {
            $URI = "https://graph.microsoft.com/v1.0/policies/" + $policyType + "/" + $id
        }
        $Method = "DELETE"
        if ($PSBoundParameters.ContainsKey("Debug")) {
            $params["Debug"] = $Null
        }
        if ($PSBoundParameters.ContainsKey("Verbose")) {
            $params["Verbose"] = $Null
        }
        if($null -ne $PSBoundParameters["WarningVariable"])
        {
            $params["WarningVariable"] = $PSBoundParameters["WarningVariable"]
        }
        if($null -ne $PSBoundParameters["InformationVariable"])
        {
            $params["InformationVariable"] = $PSBoundParameters["InformationVariable"]
        }
	    if($null -ne $PSBoundParameters["InformationAction"])
        {
            $params["InformationAction"] = $PSBoundParameters["InformationAction"]
        }
        if($null -ne $PSBoundParameters["OutVariable"])
        {
            $params["OutVariable"] = $PSBoundParameters["OutVariable"]
        }
        if($null -ne $PSBoundParameters["OutBuffer"])
        {
            $params["OutBuffer"] = $PSBoundParameters["OutBuffer"]
        }
        if($null -ne $PSBoundParameters["ErrorVariable"])
        {
            $params["ErrorVariable"] = $PSBoundParameters["ErrorVariable"]
        }
        if($null -ne $PSBoundParameters["PipelineVariable"])
        {
            $params["PipelineVariable"] = $PSBoundParameters["PipelineVariable"]
        }
        if($null -ne $PSBoundParameters["ErrorAction"])
        {
            $params["ErrorAction"] = $PSBoundParameters["ErrorAction"]
        }
        if($null -ne $PSBoundParameters["WarningAction"])
        {
            $params["WarningAction"] = $PSBoundParameters["WarningAction"]
        }
        Write-Debug("============================ TRANSFORMATIONS ============================")
        $params.Keys | ForEach-Object {"$_ : $($params[$_])" } | Write-Debug
        Write-Debug("=========================================================================`n")
        $response = Invoke-GraphRequest -Headers $customHeaders -Uri $uri -Method $Method
        $response
    }     
}