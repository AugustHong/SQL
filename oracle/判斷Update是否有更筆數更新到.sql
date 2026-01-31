-- 如果 修改無資料 可用這邊查到
CREATE OR REPLACE PROCEDURE TEST_SP IS

BEGIN

  UPDATE TableA A
  SET A.NAME = '123'
  WHERE A.ID > 10000;

  --用 SQL%NOTFOUND 就可以知道有沒有異動的筆數(如果沒有就用Insert)
  -- 不然也可以用老方法 先用 SELECT COUNT(0) 找看看再判斷也行
  IF SQL%NOTFOUND THEN
    INSERT INTO TableA (ID, NAME) VALUES (10000, '123');
  END IF;

  -- 有更新到幾筆
  IF SQL%ROWCOUNT > 1 THEN
    -- 有多筆被更新到
  END IF;

END;
/

