-- 多個資料 找第1個非空白、最大、最小
SELECT COALESCE(NULL, 3, 4, NULL) FROM DUAL; --出現 3
SELECT GREATEST(1, 5, 7, 2, 3) FROM DUAL;  --抓最大， 出現 7
SELECT LEAST(1, 5, 7, 2, 3) FROM DUAL;  --抓最小， 出現 1