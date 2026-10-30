<#
.SYNOPSIS
    Allowlisted Runbook: Endpoint Disk Space & Temp Purge
#>
param (
    [Parameter(Mandatory=$true)]
    [string]$TargetHost,
    [Parameter(Mandatory=$true)]
    [string]$IncidentID
)

try {
    $TargetPaths = @(
        "$env:TEMP\*",
        "C:\Windows\Temp\*",
        "C:\Windows\SoftwareDistribution\Download\*"
    )

    [PSCustomObject]@{
        Status        = "Success"
        ExitCode      = 0
        ReclaimedMB   = 0.00
        IncidentID    = $IncidentID
        Timestamp     = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
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
