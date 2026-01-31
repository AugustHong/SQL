-- 對SP啟用執行 最高權限，像有些語法一般的寫法是不能用的 所以要加上 AUTHID CURRENT_USER
create or replace procedure AUTH(P_DATE IN VARCHAR2, P_BACKUP IN VARCHAR2 DEFAULT 'Y') AUTHID CURRENT_USER IS

  BEGIN

    -- 執行 備份語法，並重新產生Table (當然index…那些就不見了)
    execute immediate 'ALTER TABLE TableA RENAME TO TableA'|| P_DATE;
    execute immediate 'CREATE TABLE TableA as select * from TableA'|| P_DATE ||' where 1=2';

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20001, 'ERROR ' || SQLERRM);
      rollback;
  END;
/

