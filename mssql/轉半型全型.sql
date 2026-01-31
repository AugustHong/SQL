/* 轉全型/半型 (Oracle 有自己的函式( TO_MULTI_BYTE 和 TO_SINGLE_BYTE)，但MSSQL好像沒有。看大家都用這個)
    參考網址： https://topic.alibabacloud.com/tc/a/full-width-conversion-from-sql-server-database-to-half-width_1_42_32417342.html
*/

-- 先建立 Function
CREATE FUNCTION f_Convert(
    @str NVARCHAR(4000), --要轉換的字串
    @flag bit --轉換標誌,0轉換成半形,1轉換成全形
)RETURNS nvarchar(4000)
AS
BEGIN
    DECLARE @pat nvarchar(8),@step int,@i int,@spc int
    IF @flag=0
        SELECT @pat=N'%[！-～]%',@step=-65248,
        @str=REPLACE(@str,N'　 ',N' ')
    ELSE
        SELECT @pat=N'%[!-~]%',@step=65248,
        @str=REPLACE(@str,N' ',N'　 ')
        SET @i=PATINDEX(@pat COLLATE LATIN1_GENERAL_BIN,@str)

        WHILE @i> 0
            SELECT @str=REPLACE(@str, SUBSTRING(@str,@i,1),NCHAR(UNICODE(SUBSTRING(@str,@i,1))+@step))
            ,@i=PATINDEX(@pat COLLATE LATIN1_GENERAL_BIN,@str)

    RETURN(@str)
END;

-------------------------------------------------------------------------
-- 實際呼叫  (我沒特別用 nvarchar ，感覺用 varchar 也會套用)
SELECT dbo.f_Convert('ABC你好', 1);
SELECT dbo.f_Convert('ＡＢＣ你好', 0);
-------------------------------------------------------------------------
