-- 第1步： 取得變數
DECLARE @TODAY DATE = CONVERT(DATE, GETDATE(), 0);
DECLARE @TODAY_STR VARCHAR(8) = CONVERT(VARCHAR(8), @TODAY, 112);
DECLARE @TARGET_SCHEMA VARCHAR(20) = 'dbo';
DECLARE @TARGET_TABLE VARCHAR(100) = 'ABC';
DECLARE @TARGET VARCHAR(130) = @TARGET_SCHEMA + '.' + @TARGET_TABLE;
DECLARE @TARGET_STR VARCHAR(140) = @TARGET + '_' + @TODAY_STR;
DECLARE @TARGET_STR_NO_SCHEMA VARCHAR(140) = @TARGET_TABLE + '_' + @TODAY_STR;
DECLARE @TRIGGER_STR VARCHAR(200) = 'TRG_' + @TARGET_TABLE + '_READONLY';
DECLARE @SQL VARCHAR(MAX);

-- 第2步： 先取消這張TABLE 的權限 (備註：一直在寫入的話會失敗，請找適合的時間執行)
/*
-- 語法 REVOKE INSERT ON {YourSchemaName.YourTableName} FROM {YourUserName};
-- 撤銷插入權限 
REVOKE INSERT ON [dbo].[ABC] FROM Web; 
-- 撤銷更新權限 
REVOKE UPDATE ON [dbo].[ABC] FROM Web; 
-- 撤銷刪除權限 
REVOKE DELETE ON [dbo].[ABC] FROM Web;
*/
-- 上面的執行起來還是沒辦法可以作業，所以建Trigger
SET @SQL = 'CREATE TRIGGER ' + @TRIGGER_STR + ' ' +
            'ON ' + @TARGET + ' ' + 
            'INSTEAD OF INSERT, UPDATE, DELETE' + ' ' +
            'AS' + ' ' +
            'BEGIN' + ' ' +
            'RAISERROR(''This ' + @TARGET + ' is read-only.'', 16, 1);' + ' ' +
            'ROLLBACK TRANSACTION;' + ' ' +
            'END;';
SELECT @SQL;
EXECUTE(@SQL); 

-- 第3步： 將 TABLE 改名
SET @SQL = 'EXEC sp_rename ''' + @TARGET + ''', ''' + @TARGET_STR_NO_SCHEMA + ''';';
SELECT @SQL;
EXECUTE(@SQL);

-- 第4步： 將原本的 PK 和 INDEX 拿掉 (因為名稱會重複)
-- 備註： 不同SCHEMA可以取相同的PK名稱，但相同的SCHEMA不能取相同的
/*
    刪除PK、FK： ALTER TABLE YourSchemaName.YourTableName DROP CONSTRAINT YourConstraintName;
    刪除INX： DROP INDEX YourIndexName ON YourSchemaName.YourTableName;
*/
DECLARE @IndexName VARCHAR(200), @IndexType VARCHAR(200), @SrotNum INT;
DECLARE OldToNewTableIndexList CURSOR FOR
SELECT DISTINCT s.IndexName, s.IndexType, s.SortNum
FROM
(
	SELECT i.name AS IndexName, t.IndexType, t.SortNum
	FROM sys.indexes i 
	INNER JOIN sys.index_columns ic 
	ON i.object_id = ic.object_id 
	AND i.index_id = ic.index_id 
	INNER JOIN sys.columns c 
	ON ic.object_id = c.object_id 
	AND ic.column_id = c.column_id 
	OUTER APPLY (
		SELECT CASE 
				WHEN i.is_primary_key = 1 THEN 'PK' 
				WHEN i.is_unique = 1 THEN 'Unique Index' 
				ELSE 'Non-Unique Index' 
				END AS IndexType,
				IIF(i.is_primary_key = 1, 1, 99) SortNum
	) t
	WHERE i.object_id = OBJECT_ID(@TARGET_STR)
	UNION
	SELECT
	fk.name AS IndexName, 'FK' AS IndexType, 2 AS SortNum
	FROM sys.foreign_keys AS fk 
	INNER JOIN sys.tables AS tp ON fk.parent_object_id = OBJECT_ID(@TARGET_STR)
) s
ORDER BY s.SortNum, s.IndexName;

OPEN OldToNewTableIndexList

	FETCH NEXT FROM OldToNewTableIndexList INTO @IndexName, @IndexType, @SrotNum

	WHILE @@FETCH_STATUS = 0
	BEGIN

        IF @IndexType IN('PK', 'FK')
        BEGIN
            SET @SQL = 'ALTER TABLE ' + @TARGET_STR + ' DROP CONSTRAINT ' + @IndexName + ' ;';
			-- 或者重新命名 EXEC sp_rename 'dbo.my_table.PK_OldName', 'PK_NewName', 'OBJECT';
            SELECT @SQL;
            EXECUTE(@SQL);
        END
        ELSE
        BEGIN
            SET @SQL = 'DROP INDEX ' + @IndexName + ' ON ' + @TARGET_STR + ';';
			-- 可以改使用 Rename來做，這樣要查這張表時還是可以使用。 只是不要讓其撞名而已。但通常會用這樣就是大資料，用rename會跑很久
   			--DECLARE @NewIndexName VARCHAR(200) = REPLACE(@IndexName, @TARGET_TABLE, @TARGET_STR_NO_SCHEMA);
   			--SET @SQL = 'EXEC sp_rename ''' + @TARGET_STR_NO_SCHEMA + '.' + @IndexName + ''', ''' + @NewIndexName + ''', ''INDEX'';';
            SELECT @SQL;
            EXECUTE(@SQL);
        END

        FETCH NEXT FROM OldToNewTableIndexList INTO @IndexName, @IndexType, @SrotNum
	END
CLOSE OldToNewTableIndexList;
DEALLOCATE OldToNewTableIndexList;

-- 第5步： 建立原本的 TABLE (含PK和INDEX) (依各自Table要獨立寫)
-- 備註： 若是有 AutoIncrement的依情況自已決定是否要處置！！
-- 備註： 用匯出的會有 GO 語句，記得全部拿掉！！
---------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
---------------------這段不在匯出SQL中，是防紅色的(要記得換名稱)--------------------------------
IF (OBJECT_ID(N'[dbo].[ABC]') IS NOT NULL)
BEGIN
	DROP TABLE [dbo].[ABC]
END;
---------------------------------------------------------------------------------
-- 底下放匯出的SQL 語法，從 CREATE TABLE (注意： GO 語法都要拿掉)
CREATE TABLE [dbo].[ABC](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ABC] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABC', @level2type=N'COLUMN',@level2name=N'ID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NAME' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABC', @level2type=N'COLUMN',@level2name=N'NAME'
--------------------------------------------------------------------------------------------------------
SELECT '已建立新TABLE完成';

-- 第6步： 將原TABLE解除唯讀
/*
-- 授予插入權限
GRANT INSERT ON YourSchemaName.NewTableName TO YourUserName;
-- 授予更新權限
GRANT UPDATE ON YourSchemaName.NewTableName TO YourUserName;
-- 授予刪除權限
GRANT DELETE ON YourSchemaName.NewTableName TO YourUserName;
*/
-- 上面的執行起來還是沒辦法可以作業，所以Drop Trigger
SET @SQL = 'DROP TRIGGER ' + @TRIGGER_STR + ';';
SELECT @SQL;
EXECUTE(@SQL);