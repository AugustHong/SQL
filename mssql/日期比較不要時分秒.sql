/*因為日期比較有時不要時、分、秒。 在Oracle 有 TRUNC(SYSDATE) 這樣來做，這邊也是一樣的功用*/
SELECT CAST(GETDATE() AS DATE);

-- 答案竟然是 轉成DATE型態，不是 Datetime即可