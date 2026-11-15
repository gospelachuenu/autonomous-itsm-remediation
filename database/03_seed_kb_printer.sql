USE [d3353718];
GO

-- ============================================================================
-- 03_seed_kb_printer.sql
-- Seeds Article 2: Network Printer Showing Offline / Print Spooler Service Restart
-- ============================================================================

BEGIN TRANSACTION;

DECLARE @ArticleID INT;
DECLARE @Step1ID INT, @Step2ID INT, @Step3ID INT, @Step4ID INT;

-- 1. Master KB Article
INSERT INTO dbo.KB_Articles (
    Title, Category, Keywords, IsActive, Symptoms, Prerequisites, EstimatedMinutes, EscalationPath
)
VALUES (
    N'Resolve Printer Showing Offline Status via Print Spooler Restart',
    N'Hardware & Peripherals',
    N'printer, offline, print, spooler, queue, stuck, printing, document, spoolsv, devices, scanners',
    1,
    N'Printer displays "Offline" or "Use Printer Offline" in Windows Settings or the Print Queue and print jobs fail to send.',
    N'Windows 10 device; standard or local administrator access to Windows Services.',
    5,
    N'If the printer remains offline after restarting the Print Spooler service and unchecking Use Printer Offline, escalate to Tier 2 Desktop & Network Support with the printer hostname, IP address, and physical connection status.'
);

SET @ArticleID = SCOPE_IDENTITY();

-- Step 1: Confirm the Printer Offline Status in Windows Settings
INSERT INTO dbo.KB_Steps (ArticleID, StepNumber, StepTitle, InstructionText, VerificationNote)
VALUES (
    @ArticleID,
    1,
    N'Confirm the Printer Offline Status in Windows Settings',
    N'Open the print queue or navigate to Windows Settings > Devices > Printers & scanners, select the affected printer, and verify that its status displays "Offline" or "Use Printer Offline" in the title bar.',
    N'The print queue window title bar or printer status confirms the Offline state.'
);
SET @Step1ID = SCOPE_IDENTITY();

INSERT INTO dbo.KB_StepImages (StepID, ImageOrder, ImageURL, Caption)
VALUES 
    (@Step1ID, 1, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/printer-offline/printer-01-problem-offline-status.jpg?raw=true', N'Problem state showing the printer queue marked as Offline.'),
    (@Step1ID, 2, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/printer-offline/printer-02-open-settings.jpg?raw=true', N'Open Settings from the Windows 10 Start menu.'),
    (@Step1ID, 3, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/printer-offline/printer-03-open-devices.jpg?raw=true', N'Select Devices in Windows Settings.'),
    (@Step1ID, 4, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/printer-offline/printer-04-select-printer.jpg?raw=true', N'Select the affected printer under Printers & scanners.');

-- Step 2: Locate and Restart the Windows Print Spooler Service
INSERT INTO dbo.KB_Steps (ArticleID, StepNumber, StepTitle, InstructionText, VerificationNote)
VALUES (
    @ArticleID,
    2,
    N'Locate and Restart the Windows Print Spooler Service',
    N'Press Win + R, type services.msc, and press Enter. Scroll down to locate "Print Spooler", right-click it, and select "Restart". Wait for the Service Control progress bar to finish restarting the service.',
    N'The Service Control progress dialog closes cleanly and Print Spooler returns to a Running state.'
);
SET @Step2ID = SCOPE_IDENTITY();

INSERT INTO dbo.KB_StepImages (StepID, ImageOrder, ImageURL, Caption)
VALUES 
    (@Step2ID, 1, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/printer-offline/printer-05-locate-print-spooler.jpg?raw=true', N'Locate Print Spooler in the Windows Services list.'),
    (@Step2ID, 2, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/printer-offline/printer-06-restart-spooler.jpg?raw=true', N'Right-click Print Spooler and select Restart.'),
    (@Step2ID, 3, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/printer-offline/printer-07-service-control-restarting.jpg?raw=true', N'Service Control dialog restarting the Print Spooler service.');

-- Step 3: Verify Print Spooler Startup Type Is Set to Automatic
INSERT INTO dbo.KB_Steps (ArticleID, StepNumber, StepTitle, InstructionText, VerificationNote)
VALUES (
    @ArticleID,
    3,
    N'Verify Print Spooler Startup Type Is Set to Automatic',
    N'Double-click "Print Spooler" in the Services list to open its Properties window. Confirm that "Startup type" is set to "Automatic" and "Service status" reads "Running", then click OK.',
    N'Startup type is configured as Automatic and Service status displays Running.'
);
SET @Step3ID = SCOPE_IDENTITY();

INSERT INTO dbo.KB_StepImages (StepID, ImageOrder, ImageURL, Caption)
VALUES 
    (@Step3ID, 1, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/printer-offline/printer-08-verify-spooler-properties.jpg?raw=true', N'Verify Startup type is Automatic and Service status is Running in Print Spooler Properties.');

-- Step 4: Confirm the Printer Is Back Online and Ready
INSERT INTO dbo.KB_Steps (ArticleID, StepNumber, StepTitle, InstructionText, VerificationNote)
VALUES (
    @ArticleID,
    4,
    N'Confirm the Printer Is Back Online and Ready',
    N'Switch back to your printer queue window (and ensure "Use Printer Offline" is unchecked under the Printer menu) to verify that the Offline warning has cleared.',
    N'The print queue window title bar shows the printer name without the Offline warning, and the issue is resolved.'
);
SET @Step4ID = SCOPE_IDENTITY();

INSERT INTO dbo.KB_StepImages (StepID, ImageOrder, ImageURL, Caption)
VALUES 
    (@Step4ID, 1, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/printer-offline/printer-09-resolved-printer-online.jpg?raw=true', N'Resolved state showing the printer online and ready.');

COMMIT TRANSACTION;
GO