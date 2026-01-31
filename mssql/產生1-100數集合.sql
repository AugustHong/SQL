/* 產生 1 - 100 的 數 之 Table 集合*/

-- 產生 1 - 100 數
SELECT TOP 100 ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS Num FROM syscolumns, sysobjects

-- 產生 1 - 300 數
SELECT TOP 300 ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS Num FROM syscolumns, sysobjects

-- 產生 3 - 7 數
SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS Num
FROM syscolumns, sysobjects
ORDER BY 1
OFFSET 2 ROWS
FETCH NEXT 5 ROWS ONLY;