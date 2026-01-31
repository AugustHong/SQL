-- 取到 最後1個特殊字元 後面的字串
DECLARE @str varchar(1000) = 'ABCDEFG,DEJLSJdl.abc';
-- REVERSE() 是將字串相反； 但原本的CHARINDEX找到是 0 時會有問題，所以才用CASE
SELECT 
    CASE 
        WHEN (CHARINDEX('.', REVERSE(@str)) - 1) <= 0 THEN ''
        ELSE REVERSE(SUBSTRING(REVERSE(@str), 1, (CHARINDEX('.', REVERSE(@str)) - 1)))
    END
