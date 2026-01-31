create or replace procedure CURSOR_1 is

  TABLE_A_ROW TableA%ROWTYPE; --取到 TableA 資料表結構
  ID TableA.ID%TYPE;  -- 取到同 TableA 的 ID欄位 相同的型態 (用這種的就可以當ID變大時，一同變化)


  cursor C1 is
    SELECT * FROM TableA;
begin

  OPEN C1;
  FETCH C1
    INTO TABLE_A_ROW;
    EXIT WHEN C1%NOTFOUND;  --如果沒資料就離開
    --EXIT WHEN xxxxxx  --也可自己設別的條件 (可以同時有多個 EXIT 條件)

     -- 也可以不加上上面那句，想要自己判斷的話用下面
     IF C1%NOTFOUND THEN
      CLOSE C1
      RAISE_APPLICATTION_ERROR(-20001, '查無資料');
     END IF;

    -- TABLE_A_ROW.ID  TABLE_A_ROW.NAME  一樣可以就照常使用

    -- 因為上面有宣告 TABLE_A_ROW  這個Table 變數，可以直接改值去INSERT
    TABLE_A_ROW.ID := 30;
    TABLE_A_ROW.CREATE_TIME := SYSDATE;

    INSERT INTO TableA VALUES TABLE_A_ROW;

  CLOSE C1;

end;
/

