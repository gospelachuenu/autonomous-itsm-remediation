USE [d3353718];
GO

-- ============================================================================
-- 03_seed_knowledgebase.sql
-- Seeds Article 1: Microsoft Teams Update Blocker ("This version is no longer supported")
-- ============================================================================

BEGIN TRANSACTION;

DECLARE @ArticleID INT;
DECLARE @Step1ID INT, @Step2ID INT, @Step3ID INT, @Step4ID INT, @Step5ID INT;

-- 1. Master KB Article
INSERT INTO dbo.KB_Articles (
    Title, Category, Keywords, IsActive, Symptoms, Prerequisites, EstimatedMinutes, EscalationPath
)
VALUES (
    N'Resolve Microsoft Teams "This version of Teams is no longer supported" or Update Blocker',
    N'Collaboration & M365',
    N'teams, microsoft teams, version, supported, update, blocker, uninstall, msteamssetup, edge, download',
    1,
    N'Microsoft Teams opens with "This version of Teams is no longer supported" or "Teams needs an update" and blocks access.',
    N'Windows 10 device; active internet connection; standard user permissions.',
    4,
    N'If the download is blocked or MSTeamsSetup.exe fails to install due to device restrictions, escalate to End-User Computing (EUC) Tier 2.'
);

SET @ArticleID = SCOPE_IDENTITY();

-- Step 1: Click Get the latest Microsoft Teams
INSERT INTO dbo.KB_Steps (ArticleID, StepNumber, StepTitle, InstructionText, VerificationNote)
VALUES (
    @ArticleID,
    1,
    N'Open the Teams Download Page from the Warning Screen',
    N'When Microsoft Teams displays "This version of Teams is no longer supported" or asks for an update, click "Get the latest Microsoft Teams" (or "Update Teams"), then close the Microsoft Teams window.',
    N'Microsoft Edge opens to the official Microsoft Teams download website.'
);
SET @Step1ID = SCOPE_IDENTITY();

INSERT INTO dbo.KB_StepImages (StepID, ImageOrder, ImageURL, Caption)
VALUES 
    (@Step1ID, 1, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/Teams-update/01-teams-unsupported-blocker.png?raw=true', N'Microsoft Teams blocker screen with the "Get the latest Microsoft Teams" button highlighted in red.');

-- Step 2: Find Microsoft Teams in the Start Menu
INSERT INTO dbo.KB_Steps (ArticleID, StepNumber, StepTitle, InstructionText, VerificationNote)
VALUES (
    @ArticleID,
    2,
    N'Locate the Outdated Teams App in the Start Menu',
    N'Before downloading the new installer, click the Windows Start button and search for "Microsoft Teams" (or scroll to M in the app list).',
    N'The existing Microsoft Teams app appears in the Start Menu.'
);
SET @Step2ID = SCOPE_IDENTITY();

INSERT INTO dbo.KB_StepImages (StepID, ImageOrder, ImageURL, Caption)
VALUES 
    (@Step2ID, 1, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/Teams-update/02-start-menu-locate-teams.png?raw=true', N'Windows 10 Start Menu with Microsoft Teams highlighted in red.');

-- Step 3: Uninstall the Old Teams App
INSERT INTO dbo.KB_Steps (ArticleID, StepNumber, StepTitle, InstructionText, VerificationNote)
VALUES (
    @ArticleID,
    3,
    N'Uninstall the Outdated Version of Teams',
    N'Right-click on "Microsoft Teams" in the Start Menu and click "Uninstall" to remove the old version cleanly.',
    N'The outdated Microsoft Teams app is uninstalled so you do not end up with duplicate apps.'
);
SET @Step3ID = SCOPE_IDENTITY();

INSERT INTO dbo.KB_StepImages (StepID, ImageOrder, ImageURL, Caption)
VALUES 
    (@Step3ID, 1, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/Teams-update/03-start-menu-uninstall.png?raw=true', N'Right-click menu on Microsoft Teams with Uninstall highlighted in red.');

-- Step 4: Download and Open the New Installer
INSERT INTO dbo.KB_Steps (ArticleID, StepNumber, StepTitle, InstructionText, VerificationNote)
VALUES (
    @ArticleID,
    4,
    N'Download and Run the New Teams Installer in Edge',
    N'Switch back to Microsoft Edge and click "Download Microsoft Teams for Windows". Watch the download progress bar in the top-right corner; once it finishes downloading, click the downloaded file box (MSTeamsSetup.exe / Open file).',
    N'The installer runs and installs the latest version of Microsoft Teams.'
);
SET @Step4ID = SCOPE_IDENTITY();

INSERT INTO dbo.KB_StepImages (StepID, ImageOrder, ImageURL, Caption)
VALUES 
    (@Step4ID, 1, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/Teams-update/04-edge-download-msteamssetup.png?raw=true', N'Microsoft Teams download page in Edge with the top-right Downloads box highlighting MSTeamsSetup.exe.');

-- Step 5: Launch Updated Teams
INSERT INTO dbo.KB_Steps (ArticleID, StepNumber, StepTitle, InstructionText, VerificationNote)
VALUES (
    @ArticleID,
    5,
    N'Launch and Use Microsoft Teams Normally',
    N'Once installation completes, Microsoft Teams will open automatically (or you can launch it from the Start Menu) and sign in as usual.',
    N'Microsoft Teams loads normally with no update warning banner, and the issue is fully resolved.'
);
SET @Step5ID = SCOPE_IDENTITY();

INSERT INTO dbo.KB_StepImages (StepID, ImageOrder, ImageURL, Caption)
VALUES 
    (@Step5ID, 1, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/Teams-update/05-teams-clean-launch.png?raw=true', N'Updated Microsoft Teams loading screen launching cleanly.'),
    (@Step5ID, 2, N'https://github.com/gospelachuenu/autonomous-itsm-remediation/blob/main/Teams-update/06-teams-startup.png?raw=true', N'Microsoft Teams fully loaded and ready for sign-in with the update blocker resolved.');

COMMIT TRANSACTION;
GO