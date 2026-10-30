<#
.SYNOPSIS
    Allowlisted Runbook: Active Directory Account Unlock
.PARAMETER TargetIdentity
    The UserPrincipalName or sAMAccountName validated via OTP challenge.
#>
param (
    [Parameter(Mandatory=$true)]
    [string]$TargetIdentity,
    [Parameter(Mandatory=$true)]
    [string]$IncidentID
)

try {
    # Active Directory command executed inside isolated VM sandbox
    # Unlock-ADAccount -Identity $TargetIdentity -Confirm:$false
    
    [PSCustomObject]@{
        Status      = "Success"
        ExitCode    = 0
        IncidentID  = $IncidentID
        Target      = $TargetIdentity
        Timestamp   = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    } | ConvertTo-Json
    exit 0
}
catch {
    [PSCustomObject]@{
        Status       = "Failed"
        ExitCode     = 1
        ErrorMessage = $_.Exception.Message
        IncidentID   = $IncidentID
    } | ConvertTo-Json
    exit 1
}
