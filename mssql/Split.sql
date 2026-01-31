SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SPLIT功能 (這個是網路上的，僅改寫非原創)
CREATE FUNCTION [dbo].[SPLIT] 
( 
	@SOURCE_STR nvarchar(4000), /*原始字串*/
	@SPLIT_STR varchar(50) /*分割字元*/
)
RETURNS @RESULT_TABLE TABLE
(
	[WORD] nvarchar(4000) NULL
)
BEGIN 
    DECLARE @TMP_STR nvarchar(4000), @INX INT;
    
	-- 判斷是否有包含分割字元
    WHILE (CHARINDEX(@SPLIT_STR, @SOURCE_STR) > 0) /*@SOURCE_STR有包含分割字元就一直執行迴圈*/
	BEGIN
		-- 取出 分割字元 在 資料 的位置
		SET @INX = CHARINDEX(@SPLIT_STR, @SOURCE_STR);
		-- 取出第1個，並寫入
		SET @TMP_STR = SUBSTRING(@SOURCE_STR, 1, @INX - 1); /*取出最前面的word*/
		INSERT INTO @RESULT_TABLE (WORD) VALUES (@TMP_STR);
		
		-- 把取完的清掉 (例如：A,B,C -> B,C)，再繼續往下切
		--SET @SOURCE_STR = REPLACE(@SOURCE_STR, @TMP_STR+@SPLIT_STR , ''); /*把最前面的word加上分割字元後，取代為空字串再指派回給@SOURCE_STR*/
		-- 上一行是原本的，但不好因為若是 A,B,C,A,D 的話，那第2個A不就被清掉了
		-- 改成 用SUBSTRING ，第2個參數給大一點就會切全部了
		SET @SOURCE_STR = SUBSTRING(@SOURCE_STR, (@INX + 1), 4000);
	END/*End WHILE*/
	
	IF(LEN(RTRIM(LTRIM(@SOURCE_STR))) > 0 AND CHARINDEX(@SPLIT_STR, RTRIM(LTRIM(@SOURCE_STR))) = 0) /*@SOURCE_STR有值但沒有分割字元，表示此為最後一個word*/
	BEGIN
	    SET @TMP_STR = @SOURCE_STR; /*取出word*/
	    
		INSERT INTO @RESULT_TABLE (WORD) VALUES (@TMP_STR);
	    
	END /*End IF*/

   RETURN /*回傳table變數*/
END


/*
	新版的MSSQL 有提供函式使用
*/
SELECT value FROM STRING_SPLIT('A,B,C,D,E', ',');

/*
	也可使用以下語法
*/
DECLARE @List VARCHAR(MAX) = 'A_1,B_2,C_3';
DECLARE @Delimiter VARCHAR(255) = ',';
WITH SOURCE_T AS (
SELECT Item = CONVERT(VARCHAR(MAX), Item) FROM
      ( SELECT Item = x.i.value('(./text())[1]', 'varchar(max)')
        FROM ( SELECT [XML] = CONVERT(XML, '<i>'
        + REPLACE(isnull(@List, ''), isnull(@Delimiter, ','), '</i><i>') + '</i>').query('.')
          ) AS a CROSS APPLY [XML].nodes('i') AS x(i) ) AS y
      WHERE Item IS NOT NULL
)
SELECT *
FROM SOURCE_T t;