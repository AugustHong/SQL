/*
查詢資料表資訊相關：

(A)
一、 查到所有的資料表資料：

	SELECT * FROM sysobjects WHERE  xtype = 'U';

二、查到所有的欄位資訊(可以用上面得到的id來這邊查就知道這欄位是在哪張表中)：

	SELECT * FROM syscolumns;

三、得到 表 + 欄位(且取得到 "備註" 的資訊)：

	SELECT
    		a.TABLE_NAME                as 表格名稱,
    		b.COLUMN_NAME               as 欄位名稱,
    		b.DATA_TYPE                 as 資料型別,
    		b.CHARACTER_MAXIMUM_LENGTH  as 最大長度,
    		b.COLUMN_DEFAULT            as 預設值,
    		b.IS_NULLABLE               as 允許空值,
    		(
        		SELECT
            			value
        		FROM
            			fn_listextendedproperty (NULL, 'schema', 'dbo', 'table',  
				a.TABLE_NAME, 'column', default)
        		WHERE
            			name='MS_Description' 
            			and objtype='COLUMN' 
            			and objname Collate Chinese_Taiwan_Stroke_CI_AS=b.COLUMN_NAME
    			) as 欄位備註
		FROM
    			INFORMATION_SCHEMA.TABLES  a
    			LEFT JOIN INFORMATION_SCHEMA.COLUMNS b ON (a.TABLE_NAME=b.TABLE_NAME)
		WHERE
    			TABLE_TYPE='BASE TABLE' 
		ORDER BY
    			a.TABLE_NAME, ordinal_position

(B)
這也行 

用SQL指令找出資料表資訊
https://dotblogs.com.tw/puma/2008/06/18/4326

找出資料庫裡所有的資料表

SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES ORDER BY TABLE_NAME

依資料表名稱找出所有欄位資訊

SELECT COLUMN_NAME,ORDINAL_POSITION,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Table1'

(C)我自己的精簡版：

--變數宣告
declare @tableName varchar(40) = '{tableName}';  --要查的 Table名稱
declare @pkList table (
        pkName varchar(120)
)
                                        
--把 PK 先載入裡面
insert  into @pkList (pkName)
select COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_NAME = @tableName AND CONSTRAINT_NAME like 'PK_%'; 
                                        
--得值
SELECT a.TABLE_NAME as TableName, 
b.COLUMN_NAME as ColnumName, 
b.DATA_TYPE as DataType, 
b.CHARACTER_MAXIMUM_LENGTH  as MaxLen, 
b.COLUMN_DEFAULT as DefaultValue, 
b.IS_NULLABLE  as AllowNull, 
(SELECT value 
        FROM fn_listextendedproperty (NULL, 'schema', 'dbo', 'table',  a.TABLE_NAME, 'column', default) 
        WHERE name='MS_Description' 
        AND objtype='COLUMN' 
        AND objname Collate Chinese_Taiwan_Stroke_CI_AS = b.COLUMN_NAME) 
 as Description,
 (SELECT is_identity 
       FROM sys.columns c
       INNER JOIN sys.tables ts ON ts.OBJECT_ID = c.OBJECT_ID
       where c.name = b.COLUMN_NAME 
       AND ts.name = a.TABLE_NAME) 
 AS IsAutoIncrease,
 CAST(ISNULL((select top 1 1 from @pkList where pkName = b.COLUMN_NAME), 0) as bit) as IsPK
 FROM INFORMATION_SCHEMA.TABLES  a 
 LEFT JOIN INFORMATION_SCHEMA.COLUMNS b ON (a.TABLE_NAME=b.TABLE_NAME) 
 WHERE a.TABLE_NAME = @tableName
 ORDER BY a.TABLE_NAME, ordinal_position;


 自已再整理的一版： (以上都可以使用， 就依狀況和 輸出結果即可)
 SELECT S.*,
 -- 處理 資料型別
 CASE
 WHEN S.DATA_TYPE IN ('binary', 'char', 'nchar', 'varchar', 'nvarchar', 'varbinary') THEN S.DATA_TYPE + '(' + (CASE WHEN S.IS_MAX = 'Y' THEN 'MAX' ELSE CAST(S.MAX_LENGTH AS VARCHAR) END) + ')'
 WHEN S.DATA_TYPE IN ('numeric', 'decimal') THEN S.DATA_TYPE + '(' + CAST(S.MAX_LENGTH AS VARCHAR) + ', ' + CAST(S.NUMERIC_SCALE AS VARCHAR) + ')'
 ELSE S.DATA_TYPE
 END AS A_DATA_TYPE
 FROM
 (SELECT
   a.TABLE_CATALOG,
   a.TABLE_SCHEMA,
   a.TABLE_NAME,
   a.TABLE_TYPE, -- BASE TABLE / View
   b.COLUMN_NAME               as COLUMN_NAME,
   b.DATA_TYPE                 as DATA_TYPE,
   CASE
    -- 數字型別
    WHEN b.DATA_TYPE IN ('bigint', 'decimal', 'float', 'int', 'real', 'numeric') THEN b.NUMERIC_PRECISION
    ELSE b.CHARACTER_MAXIMUM_LENGTH
   END as MAX_LENGTH,
   -- 若 CHARACTER_MAXIMUM_LENGTH = -1 其實是 MAX
   CASE
 WHEN b.CHARACTER_MAXIMUM_LENGTH = -1 THEN 'Y'
 ELSE 'N'
   END as IS_MAX,
   CASE
    -- 數字型別
    WHEN b.DATA_TYPE IN ('bigint', 'decimal', 'float', 'int', 'real', 'numeric') THEN b.NUMERIC_SCALE
    ELSE NULL  
   END as NUMERIC_SCALE,
      b.IS_NULLABLE               as NULLABLE,
   b.CHARACTER_SET_NAME  -- 字串是 big5 還是 unicode
  FROM
       INFORMATION_SCHEMA.TABLES  a
       LEFT JOIN INFORMATION_SCHEMA.COLUMNS b ON (a.TABLE_NAME=b.TABLE_NAME)
  --WHERE   a.TABLE_NAME = @ViewName
  ) AS S
  ORDER BY S.TABLE_TYPE, S.TABLE_CATALOG, S.TABLE_SCHEMA, S.TABLE_NAME
 */