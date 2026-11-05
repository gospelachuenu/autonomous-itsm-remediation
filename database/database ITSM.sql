
-- Step 1: Initialize Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'AutonomousITSM')
BEGIN
    CREATE DATABASE AutonomousITSM;
END
GO

USE AutonomousITSM;
GO

-- Step 2: Clean Drop of Existing Tables (Reverse Dependency Order)
IF OBJECT_ID('dbo.AuditLogs', 'U') IS NOT NULL DROP TABLE dbo.AuditLogs;
IF OBJECT_ID('dbo.Tickets', 'U') IS NOT NULL DROP TABLE dbo.Tickets;
IF OBJECT_ID('dbo.KnowledgeBase', 'U') IS NOT NULL DROP TABLE dbo.KnowledgeBase;
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
GO

-- =============================================================================
-- Table 1: Employees (Corporate Identity & Target Asset Directory)
-- =============================================================================
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1001, 1) PRIMARY KEY,
    UserPrincipalName NVARCHAR(100) NOT NULL UNIQUE,       -- Directory login (e.g., hollis.heales@company.local)
    FullName NVARCHAR(100) NOT NULL,
    Department NVARCHAR(50) NOT NULL,
    EmailAddress NVARCHAR(120) NOT NULL UNIQUE,          -- Destination for OTP verification challenges
    AccountStatus NVARCHAR(20) NOT NULL DEFAULT 'Active', -- 'Active', 'Locked', 'Expired'
    HostDeviceID NVARCHAR(50) NOT NULL,                   -- Target VM endpoint (e.g., 'VM-WIN10-01')
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

-- =============================================================================
-- Table 2: KnowledgeBase (Internal-First AI Grounding & Execution Rules)
-- =============================================================================
CREATE TABLE KnowledgeBase (
    KBID INT IDENTITY(1, 1) PRIMARY KEY,
    Category NVARCHAR(50) NOT NULL,                        -- 'Identity', 'EndpointStorage', 'Network'
    ArticleTitle NVARCHAR(150) NOT NULL,
    SymptomKeywords NVARCHAR(MAX) NOT NULL,                -- Match patterns evaluated by Copilot Studio
    ResolutionGuidance NVARCHAR(MAX) NOT NULL,             -- Structured guidance text synthesized by AI
    ReferenceImageURL NVARCHAR(500) NULL,                  -- Image or diagram URL (NULL until uploaded)
    ApprovedRunbook NVARCHAR(100) NULL,                    -- Allowlisted script filename (.ps1) or NULL
    RequiresOTP BIT NOT NULL DEFAULT 0,                    -- 1 = Enforces Email OTP before script trigger
    ExecutionSafetyLevel NVARCHAR(20) NOT NULL DEFAULT 'Standard',
    IsActive BIT NOT NULL DEFAULT 1
);

-- =============================================================================
-- Table 3: Tickets (ITIL 3x3 Incident Queue & Lifecycle Management)
-- =============================================================================
CREATE TABLE Tickets (
    TicketID INT IDENTITY(50001, 1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    IncidentType NVARCHAR(50) NOT NULL,                    -- 'AccountUnlock', 'DiskSpaceCleanup', 'General'
    ReportedIssue NVARCHAR(MAX) NOT NULL,                  -- Raw prompt or issue description
    Urgency NVARCHAR(10) NOT NULL DEFAULT 'Medium',        -- 'Low', 'Medium', 'High'
    Impact NVARCHAR(10) NOT NULL DEFAULT 'Low',            -- 'Low', 'Medium', 'High'
    CalculatedPriority NVARCHAR(10) NOT NULL DEFAULT 'P3', -- 'P1', 'P2', 'P3', 'P4'
    Status NVARCHAR(20) NOT NULL DEFAULT 'Open',           -- 'Open', 'In Progress', 'Resolved', 'Escalated'
    EscalatedToTier2 BIT NOT NULL DEFAULT 0,
    TriageConfidence DECIMAL(4, 2) NULL,                   -- AI classification score (e.g., 0.92)
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    ResolvedAt DATETIME2 NULL,

    CONSTRAINT FK_Tickets_Employees FOREIGN KEY (EmployeeID)
        REFERENCES Employees (EmployeeID)
);

-- =============================================================================
-- Table 4: AuditLogs (Immutable Telemetry, Exit Codes & Metrics)
-- =============================================================================
CREATE TABLE AuditLogs (
    LogID INT IDENTITY(1, 1) PRIMARY KEY,
    TicketID INT NOT NULL,
    RunbookName NVARCHAR(100) NOT NULL,                    -- Script allowlist name
    TargetHost NVARCHAR(100) NOT NULL,                     -- VM Host executed against
    ExecutionExitCode INT NOT NULL,                        -- 0 = Success, 1 = Error / Rejection
    ExecutionOutput NVARCHAR(MAX) NULL,                    -- JSON string returned by script
    StorageReclaimedMB DECIMAL(10, 2) NULL DEFAULT 0.00,   -- Delta storage reclaimed (MB)
    InitiatedBy NVARCHAR(50) NOT NULL DEFAULT 'CopilotAgent', -- 'CopilotAgent', 'Tier2Technician'
    ExecutionTimestamp DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_AuditLogs_Tickets FOREIGN KEY (TicketID)
        REFERENCES Tickets (TicketID)
);

-- Performance Indexes for Power Apps Query Filtering
CREATE NONCLUSTERED INDEX IX_Tickets_Status ON Tickets (Status);
CREATE NONCLUSTERED INDEX IX_Tickets_EmployeeID ON Tickets (EmployeeID);
CREATE NONCLUSTERED INDEX IX_AuditLogs_TicketID ON AuditLogs (TicketID);
GO

-- =============================================================================
-- Step 3: Seed Internal Knowledge Base Records
-- =============================================================================
INSERT INTO KnowledgeBase (
    Category, 
    ArticleTitle, 
    SymptomKeywords, 
    ResolutionGuidance, 
    ReferenceImageURL, 
    ApprovedRunbook, 
    RequiresOTP, 
    ExecutionSafetyLevel
)
VALUES 
(
    'Identity', 
    'Active Directory Account Unlock Verification', 
    'account locked, locked out, bad password attempts, cannot log in, domain lock, sign in failed', 
    'User account is locked in directory services due to repeated invalid password attempts. Requires verification via time-bound email OTP handshake before executing allowlisted account release.', 
    NULL, 
    'Unlock-ADAccount.ps1', 
    1, 
    'Standard'
),
(
    'EndpointStorage', 
    'Endpoint Storage Purge & Transient Cache Reclamation', 
    'c drive full, low storage, disk space alert, clear temp files, update cache full, disk space low', 
    'Endpoint primary OS partition has fallen below safe storage thresholds. Automated runbook clears noncritical transient paths ($env:TEMP, C:\Windows\Temp, SoftwareDistribution\Download) and logs reclaimed megabytes.', 
    NULL, 
    'Clear-EndpointDiskSpace.ps1', 
    0, 
    'Standard'
),
(
    'Network', 
    'Corporate Hybrid VPN Connection Troubleshooting', 
    'vpn fail, cannot connect vpn, tunnel error, remote access timeout, network disconnected', 
    'Ensure client device machine certificate is valid in Windows Certificate Store. Check network adapter configuration and reconnect via standard corporate SSO access gateway.', 
    NULL, 
    NULL, -- Informational only, no automated script execution
    0, 
    'Standard'
);
GO

-- =============================================================================
-- Step 4: Verification Check
-- =============================================================================
SELECT 'Employees' AS [Table], COUNT(*) AS [RecordCount] FROM Employees
UNION ALL
SELECT 'KnowledgeBase', COUNT(*) FROM KnowledgeBase
UNION ALL
SELECT 'Tickets', COUNT(*) FROM Tickets
UNION ALL
SELECT 'AuditLogs', COUNT(*) FROM AuditLogs;
GO
