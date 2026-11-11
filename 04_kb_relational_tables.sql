-- 1. High-level Knowledge Base Articles
CREATE TABLE KB_Articles (
    ArticleID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Category NVARCHAR(100) NOT NULL,
    Keywords NVARCHAR(500) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 2. Ordered Step-by-Step Instructions
CREATE TABLE KB_Steps (
    StepID INT IDENTITY(1,1) PRIMARY KEY,
    ArticleID INT NOT NULL,
    StepNumber INT NOT NULL,
    InstructionText NVARCHAR(MAX) NOT NULL,
    VerificationNote NVARCHAR(500) NULL,
    CONSTRAINT FK_KBSteps_Articles FOREIGN KEY (ArticleID)
        REFERENCES KB_Articles(ArticleID) ON DELETE CASCADE
);

-- 3. Multiple Screenshots / Images per Step
CREATE TABLE KB_StepImages (
    ImageID INT IDENTITY(1,1) PRIMARY KEY,
    StepID INT NOT NULL,
    ImageURL NVARCHAR(1000) NOT NULL,
    Caption NVARCHAR(300) NULL,
    CONSTRAINT FK_KBStepImages_Steps FOREIGN KEY (StepID)
        REFERENCES KB_Steps(StepID) ON DELETE CASCADE
);
