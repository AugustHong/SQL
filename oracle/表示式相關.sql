SELECT regexp_instr('指定字串', '表示式查詢', 從第幾碼開始查) FROM DUAL;  --與INSTR很像只是改成 表式示
SELECT regexp_replace('指定字串', '表示式查詢', '取代成的字串') FROM DUAL;  --與Replace很像只是改成 表式示
SELECT regexp_count('指定字串', '表示式查詢') FROM DUAL;  --用表示示查出有幾個字符合
SELECT REGEXP_SUBSTR('指定字串', '表示式查詢', 從第幾碼開始查, 取得切出來第幾個資料, [i:不區分大小寫/c:區分大小寫(預設)]) FROM DUAL; -- 用表示式切字串