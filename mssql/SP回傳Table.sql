-- MSSQL 的 SP 是可以查出 Table 的，但無法像 TableFunction 一樣用 SELECT * FROM xxx，一樣是要用 EXEC 來跑

CREATE PROCEDURE [dbo].[RETURN_TABLE_SP]
AS
BEGIN
	SELECT * FROM TableA
END