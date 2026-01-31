/* 
    Rank ，算排名。和 ROWNUM有點像。
    參考網址： https://learn.microsoft.com/zh-tw/sql/t-sql/functions/rank-transact-sql?view=sql-server-ver16
*/

-- 語法： RANK() OVER (PARTITION BY 依什麼合併 ORDER BY 排序欄位 排序方式)
-- 若是全部資料一同排名 就同範例給 PARTITION BY 1，否則若是 同個Group內排序就是 PARTITION BY GroupColumn

WITH TMP_T AS (
	SELECT 1 AS K, C4 FROM TableA WHERE PK_C <= 8
	UNION
	SELECT 2 AS K, C4 FROM TableA WHERE PK_C BETWEEN 9 AND 16
	UNION
	SELECT 3 AS K, C4 FROM TableA WHERE PK_C BETWEEN 17 AND 24
	UNION
	SELECT 4 AS K, C4 FROM TableA WHERE PK_C BETWEEN 25 AND 32
)
SELECT 
T.K, SUM(T.C4) AS S, RANK() OVER  (PARTITION BY 1 ORDER BY SUM(T.C4) DESC)
FROM TMP_T AS T
GROUP BY T.K