USE d3353718;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetKBArticleForAI
    @SearchTerm NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    -- Clean punctuation from the user's natural-language query
    DECLARE @CleanSearch NVARCHAR(500) = LOWER(TRIM(ISNULL(@SearchTerm, N'')));
    SET @CleanSearch = REPLACE(REPLACE(REPLACE(REPLACE(@CleanSearch, N'?', N''), N'!', N''), N'.', N''), N',', N'');

    DECLARE @MatchedArticleID INT;

    -- Tokenize user input and rank active KB articles by keyword match frequency (tokens >= 4 chars)
    SELECT TOP 1 @MatchedArticleID = a.ArticleID
    FROM dbo.KB_Articles a
    CROSS APPLY STRING_SPLIT(@CleanSearch, N' ') w
    WHERE a.IsActive = 1
      AND LEN(TRIM(w.value)) >= 4
      AND (
            LOWER(a.Title)    LIKE N'%' + TRIM(w.value) + N'%'
         OR LOWER(a.Keywords) LIKE N'%' + TRIM(w.value) + N'%'
         OR LOWER(a.Symptoms) LIKE N'%' + TRIM(w.value) + N'%'
      )
    GROUP BY a.ArticleID, a.CreatedDate
    ORDER BY COUNT(*) DESC, a.CreatedDate DESC;

    DECLARE @JsonResult NVARCHAR(MAX);

    -- Assemble nested 3NF JSON payload (Article -> Ordered Steps -> Ordered Step Images)
    SET @JsonResult = (
        SELECT TOP 1
            a.ArticleID,
            a.Title,
            a.Category,
            a.Symptoms,
            a.Prerequisites,
            a.EstimatedMinutes,
            a.EscalationPath,
            (
                SELECT 
                    s.StepNumber,
                    s.StepTitle,
                    s.InstructionText,
                    s.VerificationNote,
                    (
                        SELECT 
                            i.ImageOrder,
                            i.ImageURL,
                            i.Caption
                        FROM dbo.KB_StepImages i
                        WHERE i.StepID = s.StepID
                        ORDER BY i.ImageOrder
                        FOR JSON PATH
                    ) AS Images
                FROM dbo.KB_Steps s
                WHERE s.ArticleID = a.ArticleID
                ORDER BY s.StepNumber
                FOR JSON PATH
            ) AS Steps
        FROM dbo.KB_Articles a
        WHERE a.ArticleID = @MatchedArticleID
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );

    -- Return structured JSON or deterministic fallback error object
    SELECT ISNULL(@JsonResult, N'{"error":"No matching KB article found"}') AS ArticleJson;
END;
GO