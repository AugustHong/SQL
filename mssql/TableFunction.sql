/* 這個要建在 可程式性(Programmability)裡的 Functions 的 Table-valued Functions 中*/

-- 單純固定Table
CREATE FUNCTION TestFunc 
(	
	@id decimal
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT *
	FROM TableA A
	WHERE A.PK_C = @id
)
GO

----------------------------------------------------------
--實際使用：
SELECT * FROM TestFunc(1);
----------------------------------------------------------

-- 回傳特定欄位Table
CREATE FUNCTION TestFunc2 
(	
	@id1 decimal,
	@id2 decimal
)
RETURNS @result TABLE
(
	PK_C decimal,
	C1 nvarchar(50),
	C2 datetime
)
AS
BEGIN
	INSERT INTO @result
	SELECT A.PK_C, A.C1, A.C2
	FROM TableA A
	WHERE A.PK_C = @id1;

	INSERT INTO @result
	SELECT A.PK_C, A.C1, A.C2
	FROM TableA A
	WHERE A.PK_C = @id2;

	RETURN;
END;
GO

----------------------------------------------------------
--實際使用：
SELECT * FROM TestFunc2(2, 3);
----------------------------------------------------------

-- Function 預設參數 (不像Oracle不用輸入，還是要給 DEFAULT)
CREATE FUNCTION TestFunc3 
(	
	@id1 decimal = 0
)
RETURNS decmal
AS
BEGIN
	RETURN (@id1)
END;

----------------------------------------------------------
--實際使用：
SELECT * FROM TestFunc3();  --這會錯誤
SELECT * FROM TestFunc3(DEFAULT); --這才會對
----------------------------------------------------------

