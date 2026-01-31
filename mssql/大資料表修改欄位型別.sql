-- 方法一： 建1個新欄位，然後更新過去，再來刪原欄位，再改名
-- 1. 建立新的欄位
ALTER TABLE ABC ADD new_aaa VARCHAR(20);

-- 2. 分批更新資料（例如使用 ID 分段或 ROW_NUMBER）
UPDATE ABC
SET new_aaa = aaa
--WHERE id BETWEEN @StartID AND @EndID;  --自已下條件分批跑

-- 3. 刪除原欄位
ALTER TABLE ABC DROP COLUMN aaa;

-- 4. 將新欄位重新命名為原欄位名稱
EXEC sp_rename 'ABC.new_aaa', 'aaa', 'COLUMN';


--------------------------------------------------------------------------------------------------------

-- 方法二
PRINT N'開始重建資料表 [dbo].[ABC]...';

GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

-- 建立新表
CREATE TABLE [dbo].[New_ABC] (
    [ID]    SMALLINT      IDENTITY (1, 1) NOT NULL,
    [aaa]  NVARCHAR (20) NOT NULL,
    CONSTRAINT [NEW_ABC_PK] PRIMARY KEY CLUSTERED ([ID] ASC)
);

-- 寫入資料
IF EXISTS (SELECT TOP 1 1 FROM  [dbo].[ABC])
    BEGIN
        SET IDENTITY_INSERT [dbo].[NEW_ABC] ON;
        INSERT INTO [dbo].[NEW_ABC] ([ID], [aaa])
        SELECT   [ID],
                 [aaa]
        FROM     [dbo].[ABC]
        ORDER BY [ID] ASC;
        SET IDENTITY_INSERT [dbo].[NEW_ABC] OFF;
    END

-- 刪除原表
DROP TABLE [dbo].[MtClass];

-- 改名
EXECUTE sp_rename N'[dbo].[NEW_ABC]', N'ABC';
-- 改INDEX名
EXECUTE sp_rename N'[dbo].[NEW_ABC_PK]', N'ABC_PK', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;