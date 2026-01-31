--想要用byte (1個中文2byte，其他1byte)，但切出來會是用長度切
SELECT SUBSTRING('你好12301', 1, 6) 
-- 所以要先將資料轉成 varbinary 再切，切完再轉回來
SELECT CONVERT(varchar, SUBSTRING(CONVERT(varbinary, '你好12301'), 1, 6))