/* Merge Into 寫法 (如果有查到執行…  沒有查到執行…)*/

MERGE TableA AS A  --設定要寫入/修改/刪除 的Table
USING (SELECT * FROM TableB) AS B --設定要判斷的Table
ON (A.ID = B.ID)  --設定查詢條件
-- 如果有找到且有其他條件
WHEN MATCHED AND B.CLOSE_YN = 'Y' THEN
    -- 刪除的寫法  (直接寫 Delete 就行)
    -- DELETE
--如果有找到要執行的動作
WHEN MATCHED THEN
    -- 修改的寫法
    UPDATE SET A.Name = B.Name
-- 如果沒有找到的動作
WHEN NOT MATCHED THEN
    -- 新增的寫法
    INSERT INTO (ID, Name)
    VALUES (B.ID, B.Name)
-- 輸出結果 (可不寫，只是好查有哪些異動而己)，這裡的 Output還可以當作條件查
OUTPUT deleted.*, $action, inserted.* INTO #MyTempTable;


---------------------------------------------------------------------------------
--取到 只有Update動作的資料
INSERT INTO TableC
SELECT ID, Name
FROM
    (
        MERGE TableA AS A  --設定要寫入/修改/刪除 的Table
        USING (SELECT * FROM TableB) AS B --設定要判斷的Table
        ON (A.ID = B.ID)  --設定查詢條件
        WHEN MATCHED THEN
            UPDATE SET A.Name = B.Name
        WHEN NOT MATCHED THEN
            -- 新增的寫法
            INSERT INTO (ID, Name)
            VALUES (B.ID, B.Name)
        -- Insert 和 Update 都是用 Inserted.XXX 來取到的
        OUTPUT $action, Inserted.ID, Inserted.Name 
    ) AS Change (ACTION, ID, Name)
WHERE ACTION = 'UPDATE'
---------------------------------------------------------------------------------