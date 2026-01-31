-- 基本操作
SELECT *
FROM TableA a
INNER JOIN TableB b;

UPDATE TableA a SET a.ABC = '123' WHERE a.B = '10';

-- Oracle是可以用別名的 MSSQL不行，所以要串別張表可以這樣
UPDATE TableA a SET a.ABC = (SELECT b.ABC FROM TableB b WHERE b.B = a.B);

DELETE TableA a WHERE a.B = '10';

-- 剩下之後有時間再補充了