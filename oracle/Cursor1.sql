CREATE OR REPLACE PROCEDURE TEST_CURSOR(PNO IN VARCHAR2 DEFAULT Null)

  cursor C1(PNO IN VARCHAR2) is
    -- ROWID 是 Oracle比較特別的，每一個ROW都有自已的ROWID，常用在 CURSOR 中 去 UPDATE資料
    SELECT A.*, A.ROWID AS RID
    FROM TableA A
    WHERE A.NO = PNO;

BEGIN
  FOR CUR IN C1(PNO) LOOP
    -- CUR.ID, CUR.NAME  你CURSOR 有回傳哪些欄位，就可以用 CUR.欄位 來取到 (這裡的 CUR 就是 FOR CUR 的 那個 CUR)

    -- 用 ROWID更新指定
    UPDATE TableA SET NAME = '123' WHERE ROWID = CUR.RID;

    IF 1 = 1 THEN
      EXIT;  --強制離開
      --CONTINUE;  --也有繼續的，常放在 Exception那邊
    END IF;
  END LOOP;
END;
/

