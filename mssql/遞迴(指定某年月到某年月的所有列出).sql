-- 這是將 指定的 2個日期間 所有的 年月 列出來
WITH YearWeekDateRange
AS
(
-- 遞迴初始值
SELECT DATEDIFF(month, '2023/01/01', '2024/1/30') AS startMonNum
, CAST('2023/01/01' AS DATE) AS startDate
, 0 AS seq
-- 用 UNION ALL 來做遞迴 (後面拿到的就是 初始值開始往下做，然後就一直往後)
UNION ALL
SELECT startMonNum
, DATEADD(month, 1, startDate) AS startDate
, seq + 1 AS seq 
FROM YearWeekDateRange YW -- 這邊寫上 WITH 的 Table 名就會遞迴
WHERE seq < 12  -- 終止值
)
SELECT *  
FROM YearWeekDateRange;