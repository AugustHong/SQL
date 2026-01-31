-- 因為 MSSQL 的 SP 和 Function 分為 Create 語法 和 Alert 語法 (不像Oracle寫一起)，所以會導致常有錯誤。
-- 以下就是解法 (先去用 OBJECT_ID 判斷物件是否存在)

-- Table的方式：
IF (OBJECT_ID(N'[dbo].[TableA]') IS NOT NULL)
BEGIN
DROP TABLE [dbo].[TableA]
END;

CREATE TABLE [dbo].[TableA]
(
    -- TODO:
);


-- SP的方式：
IF (OBJECT_ID('TEST_SP') IS NULL)
BEGIN
EXEC ('CREATE PROCEDURE [dbo].[TEST_SP] AS BEGIN SELECT 1 END');
END
GO

ALTER PROCEDURE [dbo].[TEST_SP] (
    -- TODO:
);

-- Function的方：
IF (OBJECT_ID('TEST_FUNCTION') IS NULL)
BEGIN
EXEC ('CREATE FUNCTION [dbo].[TEST_FUNCTION]() RETURNS INT AS BEGIN RETURN 1 END');
END
GO

ALTER FUNCTION [dbo].[TEST_FUNCTION] (
    -- TODO:
);

-- View 那些應該也是相同的做法，實際要用時Select OBJECT_ID 看抓不抓得到就行
