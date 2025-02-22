# ------------------------------------------------------------------------------
#  Copyright (c) Microsoft Corporation.  All Rights Reserved.  Licensed under the MIT License.  See License in the project root for license information.
# ------------------------------------------------------------------------------
function Add-EntraScopedRoleMembership {
    [CmdletBinding(DefaultParameterSetName = 'InvokeByDynamicParameters')]
    param (    
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [System.String] $ObjectId,
    [Parameter(ParameterSetName = "InvokeByDynamicParameters")]
    [System.String] $RoleObjectId,
    [Parameter(ParameterSetName = "InvokeByDynamicParameters")]
    [Microsoft.Open.MSGraph.Model.MsRoleMemberInfo] $RoleMemberInfo
    )

    PROCESS {    
    $params = @{}
    $body = @{}
    $customHeaders = New-EntraCustomHeaders -Command $MyInvocation.MyCommand

    if($null -ne $PSBoundParameters["ObjectId"])
    {
        $params["AdministrativeUnitId"] = $PSBoundParameters["ObjectId"]
        $Uri = "/v1.0/directory/administrativeUnits/$($params.AdministrativeUnitId)/scopedRoleMembers"     
    }    
    if($null -ne $PSBoundParameters["RoleObjectId"])
    {
        $params["RoleId"] = $PSBoundParameters["RoleObjectId"]
        $body.roleId = $PSBoundParameters["RoleObjectId"];
    }
    if($null -ne $PSBoundParameters["RoleMemberInfo"])
    {
        $TmpValue = $PSBoundParameters["RoleMemberInfo"]
        $Value = @{
            id = ($TmpValue).Id
        }
        $params["RoleMemberInfo"] = $Value | ConvertTo-Json
        $body.roleMemberInfo = $Value
    }

    if($null -ne $PSBoundParameters["ErrorAction"])
    {
        $params["ErrorAction"] = $PSBoundParameters["ErrorAction"]
    }
    if($null -ne $PSBoundParameters["PipelineVariable"])
    {
        $params["PipelineVariable"] = $PSBoundParameters["PipelineVariable"]
    }
    if($null -ne $PSBoundParameters["OutVariable"])
    {
        $params["OutVariable"] = $PSBoundParameters["OutVariable"]
    }
    if($null -ne $PSBoundParameters["InformationAction"])
    {
        $params["InformationAction"] = $PSBoundParameters["InformationAction"]
    }
    if($null -ne $PSBoundParameters["WarningVariable"])
    {
        $params["WarningVariable"] = $PSBoundParameters["WarningVariable"]
    }
    if($PSBoundParameters.ContainsKey("Verbose"))
    {
        $params["Verbose"] = $PSBoundParameters["Verbose"]
    }
    if($PSBoundParameters.ContainsKey("Debug"))
    {
        $params["Debug"] = $PSBoundParameters["Debug"]
    }
    if($null -ne $PSBoundParameters["ErrorVariable"])
    {
        $params["ErrorVariable"] = $PSBoundParameters["ErrorVariable"]
    }    
    if($null -ne $PSBoundParameters["OutBuffer"])
    {
        $params["OutBuffer"] = $PSBoundParameters["OutBuffer"]
    }
    if($null -ne $PSBoundParameters["WarningAction"])
    {
        $params["WarningAction"] = $PSBoundParameters["WarningAction"]
    }
    if($null -ne $PSBoundParameters["InformationVariable"])
    {
        $params["InformationVariable"] = $PSBoundParameters["InformationVariable"]
    }

    Write-Debug("============================ TRANSFORMATIONS ============================")
    $params.Keys | ForEach-Object {"$_ : $($params[$_])" } | Write-Debug
    Write-Debug("=========================================================================`n")
    
    $response = Invoke-GraphRequest -Headers $customHeaders -Uri $Uri -Method "POST" -Body $body
    $response = $response | ConvertTo-Json -Depth 5 | ConvertFrom-Json
    $response | ForEach-Object {
        if($null -ne $_) {
            Add-Member -InputObject $_ -MemberType AliasProperty -Name AdministrativeUnitObjectId -Value AdministrativeUnitId
            Add-Member -InputObject $_ -MemberType AliasProperty -Name RoleObjectId -Value RoleId
            Add-Member -InputObject $_ -MemberType AliasProperty -Name ObjectId -Value Id
        }
    }
    
    $memberList = @()
    foreach($data in $response){
        $memberType = New-Object Microsoft.Graph.PowerShell.Models.MicrosoftGraphScopedRoleMembership
        if (-not ($data -is [psobject])) {
            $data = [pscustomobject]@{ Value = $data }
        }
        $data.PSObject.Properties | ForEach-Object {
            $propertyName = $_.Name
            $propertyValue = $_.Value
            $memberType | Add-Member -MemberType NoteProperty -Name $propertyName -Value $propertyValue -Force
        }
        $memberList += $memberType
    }
    $memberList  

    }
}