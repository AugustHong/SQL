CREATE OR REPLACE TRIGGER test_trg
  before insert or UPDATE or delete on TableA  --在 TableA 新增 或 修改 前觸發 (可把 before 改成 after 就是觸發後觸發)
  for each row --跑每一筆
declare
  -- 變數
  vInx INT;
begin

  -- 新增 或 修改 時
  IF INSERTING OR UPDATING OR DELETING THEN
    -- 新的 文字 :new 就可以了； 在猜 舊的應該是 :old
    INSERT INTO TableA_Log (TEXT) VALUES (:new.TEXT);
  END IF;

end test_trg;
/

