SELECT TRIM(' ABC ') FROM DUAL;  --去掉空白  結果 'ABC'
SELECT LTRIM(' ABC ') FROM DUAL;  --去掉左邊空白 結果 'ABC '
SELECT RTRIM(' ABC ') FROM DUAL;  --去掉右邊空白 結果 ' ABC'
SELECT LTRIM( '@str', '@' ) FROM DUAL; -- 結果: str
SELECT RTRIM( 'str@', '@' ) FROM DUAL; -- 結果: str