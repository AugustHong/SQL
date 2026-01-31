ALTER PROCEDURE [dbo].[SP_TEST] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --定義Cursor並打開
DECLARE MyCursor Cursor FOR --宣告，名稱為MyCursor
-- 此區段就可以撰寫你的資料集
select PK_C, C1 from TableA where C1 like '%A%'

Open MyCursor 

print @@CURSOR_rows --查看總筆數(目前都是得到-1，不知為什麼)

--定義ID變數
declare @id int, @name nvarchar(50), @detailText varchar(1000)

--開始迴圈跑Cursor Start
Fetch NEXT FROM MyCursor INTO @id, @name
While (@@FETCH_STATUS <> -1)
BEGIN

	--此區塊就可以處理商業邏輯，譬如利用tableA的ID將資料塞入tableB
	PRINT 'ID = ' + CAST(@id AS varchar(10))
	PRINT 'NAME = ' + @name

	-- 第二段Cursor
	DECLARE MyCursor2 Cursor FOR 
	select ISNULL(C5, 'NULL') AS D from TableA where PK_C = @id
	Open MyCursor2
	Fetch NEXT FROM MyCursor2 INTO @detailText
	While (@@FETCH_STATUS <> -1)
	BEGIN
		PRINT 'TEXT = ' + @detailText
		Fetch NEXT FROM MyCursor2 INTO @detailText
	END
	CLOSE MyCursor2
	DEALLOCATE MyCursor2

	PRINT '--------------------------------------------'
	Fetch NEXT FROM MyCursor INTO @id, @name
END

--關閉&釋放cursor
CLOSE MyCursor
DEALLOCATE MyCursor
END