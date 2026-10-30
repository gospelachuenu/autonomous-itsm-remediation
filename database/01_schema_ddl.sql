-- BSc (Hons) IT Project: Database DDL Schema (3NF)
-- Table definitions for Users, Incident Queue, and Execution Audit Telemetry

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    UserPrincipalName NVARCHAR(100) NOT NULL UNIQUE,
    FullName NVARCHAR(100) NOT NULL,
    Department NVARCHAR(50) NOT NULL,
    AccountStatus NVARCHAR(20) DEFAULT 'Active',
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE Tickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    IncidentType NVARCHAR(50) NOT NULL,
    ReportedIssue NVARCHAR(MAX) NOT NULL,
    Priority NVARCHAR(10) DEFAULT 'P3',
    Status NVARCHAR(20) DEFAULT 'Open',
    CreatedAt DATETIME DEFAULT GETDATE(),
    ResolvedAt DATETIME NULL
);

CREATE TABLE AuditLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT FOREIGN KEY REFERENCES Tickets(TicketID),
    RunbookName NVARCHAR(100) NOT NULL,
    TargetHost NVARCHAR(100) NOT NULL,
    ShellExitCode INT NOT NULL,
    ExecutionOutput NVARCHAR(MAX) NULL,
    StorageReclaimedMB DECIMAL(10,2) NULL,
    LoggedAt DATETIME DEFAULT GETDATE()
);
