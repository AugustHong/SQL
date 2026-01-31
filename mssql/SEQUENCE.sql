CREATE SEQUENCE [dbo].[TestCnt] 
 AS [int]  --類型
 START WITH 1  --從多少開始
 INCREMENT BY 1  --每次增加多少(可以給 -1)
 MINVALUE 1  --最小值
 MAXVALUE 99999 --最大值
 CYCLE -- 是否循環(指 超過 最大/最小值 就會從 最小值開始)
 NO CACHE  -- 是否有 CACHE
GO

--------------------------------------------------------------
-- 實際呼叫
-- 要看這個 sequence 的 屬性 (後面的name 就是 sequence 的名稱)
SELECT * FROM sys.sequences WHERE name = 'TestCnt' ; 

-- 取得 序號值
SELECT NEXT VALUE FOR TestCnt;  -- 1
SELECT NEXT VALUE FOR TestCnt;  -- 2 (會自己增加了)
--------------------------------------------------------------