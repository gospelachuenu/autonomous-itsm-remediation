USE AutonomousITSM;
GO

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
-- Informational Guide 1: Outlook Cache
(
    'Applications',
    'Outlook Desktop Profile & OST Cache Sync Issue',
    'outlook disconnected, outlook stuck processing, ost corrupt, mailbox not updating, outlook sync error',
    'Locate client data directory under %LOCALAPPDATA%\Microsoft\Outlook. Advise user to close Outlook completely, verify network connection, and restart Outlook in Safe Mode (outlook.exe /safe) to regenerate local cache safely.',
    NULL,
    NULL,
    0,
    'Standard'
),
-- Informational Guide 2: Print Spooler Local Reset
(
    'Hardware',
    'Local Workstation Print Spooler Clearing',
    'printer jammed queue, print spooler error, cannot print document, printer offline document waiting',
    'Open Windows Services console (services.msc). Stop the Print Spooler service. Navigate to C:\Windows\System32\spool\PRINTERS and clear old print spool files before restarting the service.',
    NULL,
    NULL,
    0,
    'Standard'
),
-- Informational Guide 3: Multi-Factor Authentication (MFA) App Rebinding
(
    'Identity',
    'Microsoft Authenticator Device Re-registration',
    'mfa broken, new phone authenticator, lost 2fa, authenticator prompt not showing, push notification failing',
    'Self-service MFA reset requires prior identity validation. Direct employee to the corporate security portal (aka.ms/mfasetup) while on the internal network to scan the updated QR code.',
    NULL,
    NULL,
    0,
    'Standard'
),
-- Security Boundary Guide 1: Password Resets (Requires Helpdesk Verification)
(
    'Identity',
    'Enterprise Password Reset Request Policy',
    'forgot password, reset my password, expired domain password, change login password',
    'Self-service password resets are restricted under Phase 1 MVP governance. User must be redirected to the corporate SSPR self-service portal or escalated to Tier-2 technician queue for live identity verification.',
    NULL,
    NULL,
    0,
    'Standard'
),
-- Security Boundary Guide 2: Administrative Software Installation (Restricted)
(
    'Security',
    'Local Administrator Rights & Software Installation Requests',
    'need admin rights, install chrome, install unapproved app, run as administrator prompt, uac block',
    'Standard domain workstations strictly enforce least-privilege policies. Standard employees cannot be granted local admin rights. Direct the user to the Company Portal app store or escalate ticket to Software Delivery for packaging review.',
    NULL,
    NULL,
    0,
    'Standard'
),
-- Informational Guide 4: Microsoft Teams Audio / Peripheral Troubleshooting
(
    'Applications',
    'Microsoft Teams Audio & Microphone Device Routing',
    'teams mic not working, cannot hear in teams, headset not detected, teams audio echo',
    'Navigate to Teams Settings > Devices. Check the Audio Devices dropdown to ensure the correct USB or Bluetooth headset is selected. Ensure Windows Privacy Settings allows desktop apps access to the microphone.',
    NULL,
    NULL,
    0,
    'Standard'
),
-- Informational Guide 5: Wi-Fi Certificate Renewal
(
    'Network',
    'Corporate 802.1X Wireless Certificate Renewal',
    'wifi prompt invalid cert, corporate wifi rejected, cannot connect to office wifi, wifi authentication error',
    'Verify that the corporate root CA certificate is installed in the Windows Local Computer Personal store. Toggle Wi-Fi off and on. If prompt persists, forget the corporate SSID and reconnect using domain credentials.',
    NULL,
    NULL,
    0,
    'Standard'
);
GO

-- Verify total knowledge base records
SELECT KBID, Category, ArticleTitle, ApprovedRunbook, RequiresOTP 
FROM KnowledgeBase;
GO
