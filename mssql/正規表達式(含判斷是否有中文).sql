-- 判斷是否含中文
SELECT CASE WHEN PATINDEX('%[^A-Za-z0-9\s]%', '你好') > 0 THEN '包含中文' ELSE '不包含中文' END;

-- 看起來 PATINDEX 就是可以用正規表達式的方式來處理