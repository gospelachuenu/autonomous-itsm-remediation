USE AutonomousITSM;
GO

-- Optional: Clear existing employee records if re-seeding
-- (Will only execute if no child tickets reference these IDs yet)
-- DELETE FROM dbo.Employees;
-- DBCC CHECKIDENT ('dbo.Employees', RESEED, 1000);
-- GO

INSERT INTO Employees (
    UserPrincipalName, 
    FullName, 
    Department, 
    EmailAddress, 
    AccountStatus, 
    HostDeviceID
)
VALUES
-- Core Test Identities (Pre-configured as Locked for OTP & AD Unlock validation)
('hollis.heales@company.local',   'Hollis Heales',   'Finance',          'hollis.heales@company.local',   'Locked',  'VM-WIN10-01'),
('marcus.vance@company.local',    'Marcus Vance',    'Engineering',      'marcus.vance@company.local',    'Locked',  'VM-WIN10-01'),
('james.wilson@company.local',    'James Wilson',    'Sales',            'james.wilson@company.local',    'Locked',  'VM-WIN10-01'),

-- Baseline Active Employees (Standard departmental accounts for disk purges and inquiries)
('sarah.connor@company.local',    'Sarah Connor',    'Operations',       'sarah.connor@company.local',    'Active',  'VM-WIN10-01'),
('elena.rostova@company.local',   'Elena Rostova',   'Human Resources',  'elena.rostova@company.local',   'Active',  'VM-WIN10-01'),
('david.kim@company.local',       'David Kim',       'Marketing',        'david.kim@company.local',       'Active',  'VM-WIN10-01'),
('rachel.adams@company.local',    'Rachel Adams',    'Legal',            'rachel.adams@company.local',    'Active',  'VM-WIN10-01'),
('priya.patel@company.local',     'Priya Patel',     'IT Support',       'priya.patel@company.local',     'Active',  'VM-WIN10-01'),
('lucas.meyer@company.local',     'Lucas Meyer',     'Logistics',        'lucas.meyer@company.local',     'Active',  'VM-WIN10-01'),
('amina.bello@company.local',     'Amina Bello',     'Customer Success', 'amina.bello@company.local',     'Active',  'VM-WIN10-01');
GO

-- =============================================================================
-- Verification Query
-- =============================================================================
SELECT 
    EmployeeID,
    FullName,
    Department,
    UserPrincipalName,
    EmailAddress,
    AccountStatus,
    HostDeviceID,
    CreatedAt
FROM Employees
ORDER BY EmployeeID ASC;
GO
