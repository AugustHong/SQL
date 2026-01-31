-- 基本操作
SELECT *
FROM TableA a
INNER JOIN TableB b
ON a.A = b.A
;

-- MSSQL 不行使用別名
UPDATE TableA SET ABC = '123' WHERE B = '10';
-- 所以遇到要串別張表的要這樣寫
UPDATE a
SET a.ABC = b.ABC
FROM TableA a
LEFT JOIN TableB b
ON a.B = b.B
;


DELETE TableA  WHERE B = '10';
-- 刪除同理
DELETE a
FROM TableA a
INNER JOIN TableB b
ON a.B = b.B
;

-- 剩下之後有時間再補充了