/*
    outer apply 看起來就和 一般查詢的一樣，但可以減少一層 括號。
    如下舉例
*/

-- 以下結果相同
SELECT A.*, (SELECT COUNT(0) FROM TableB B WHERE B.ID = A.ID) AS B_CNT
FROM TableA A;

SELECT A.*, BC.B_CNT
FROM TableA A
OUTER APPLY (
    SELECT COUNT(0) AS B_CNT FROM TableB B WHERE B.ID = A.ID
) BC;

-- 但若要拿 B_CNT做運算的話 就可以少一層
SELECT S.*
FROM (
    SELECT A.*, (SELECT COUNT(0) FROM TableB B WHERE B.ID = A.ID) AS B_CNT
    FROM TableA A
) S
WHERE S.B_CNT > 2;

SELECT A.*, BC.B_CNT
FROM TableA A
OUTER APPLY (
    SELECT COUNT(0) AS B_CNT FROM TableB B WHERE B.ID = A.ID
) BC
WHERE BC.B_CNT > 2;