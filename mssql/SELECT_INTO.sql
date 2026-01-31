SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SelectInto] 
	@ID int = 1
AS
BEGIN
	DECLARE @C1 NVARCHAR(50), @C2 DATETIME;

	-- 單純給值 (可用 SET 或 SELECT 都可以)
	SET @C1 = 'TEST';
	SELECT @C1 = 'TEST2';

	-- Select Into 給變數的寫法 (但應該和Oracle一樣，一定要一筆不然會有錯誤)
	SELECT @C1 = C1, @C2 = C2
	FROM TableA
	WHERE PK_C = @ID;
END