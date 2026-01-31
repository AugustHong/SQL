/* 像 Oracle 的 Create AS 語法，快速將1個Table 複製成新的1個Talbe*/

-- 這個會實際長出 TableB 喔
SELECT * INTO TableB FROM TableA;

-- 如果是平常的暫存Table 就要記得 Drop 掉
SELECT * INTO #Tmp FROM TableA;
SELECT * FROM #Tmp WHERE C1 LIKE '%測試%'
DROP TABLE #Tmp;