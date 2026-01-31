-- 執行SQL語法 (2種寫法)

EXECUTE('SELECT 1 AS T');

-- 第二種
DECLARE @Sql NVARCHAR(MAX), @I INT = 50, @D DATE = CONVERT(DATE, GETDATE(), 0), @T VARCHAR(30) = 'ABC';
SET @Sql = N'SELECT GETDATE() AS NOW, @I AS I, @D AS D, @T AS T';
-- 第1個參數： 執行的SQL語法，裡面可以帶變數
-- 第2個參數： 要帶入的變數名稱
-- 第3個參數： 實際的變數
EXEC sp_executesql @Sql, N'@I INT, @D DATE, @T VARCHAR(30)', @I, @D, @T;