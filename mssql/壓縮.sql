/*
    DB名稱： 就是 用SSMS後展開來的 DB清單
    Table名稱： 就是指定的 Table
*/

-- 壓縮Table
ALTER TABLE [DB名稱].[dbo].[Table名稱] REBUILD WITH (DATA_COMPRESSION = PAGE);

-- 壓縮DB
/*
-- 收縮整個資料庫，保留 10% 空間
DBCC SHRINKDATABASE (DB名稱, 10);

-- 只釋放尾端空間
DBCC SHRINKDATABASE (DB名稱, TRUNCATEONLY);

-- 收縮目前資料庫
DBCC SHRINKDATABASE (0, 5);
*/
/*
避免頻繁操作：收縮會造成 索引碎片化，影響查詢效能。

適用場景：
大量刪除資料後釋放空間
清理臨時性資料庫
資料庫遷移前的優化

不建議作為日常維護：正常業務成長不需定期收縮。
建議搭配索引重建：收縮後執行 ALTER INDEX ... REBUILD 或 REORGANIZE 減少碎片
*/
USE [DB名稱]; CHECKPOINT; DBCC SHRINKDATABASE (DB名稱, TRUNCATEONLY);

-- 壓縮DB(單一資料檔或記錄檔的命令)
/*
-- 將檔案收縮到 7 MB
DBCC SHRINKFILE (DataFile1, 7);

-- 清空檔案以便刪除
DBCC SHRINKFILE (DataFile2, EMPTYFILE);

-- 只釋放尾端空間
DBCC SHRINKFILE (LogFile1, TRUNCATEONLY);
*/
/*
剩下皆與上面差不多的參數
*/
USE [DB名稱]; CHECKPOINT; DBCC SHRINKFILE (DB名稱, 4000); DBCC SHRINKFILE (DB名稱_log, 10);

-- 配合壓縮後要 減少碎片化 (ALTER INDEX ... BEBUILD) 動作
/*
ONLINE = ON	線上重建，減少鎖定，需 Enterprise 版
FILLFACTOR	設定頁面填充比例，保留空間以減少頁面分裂
SORT_IN_TEMPDB = ON	在 tempdb 中排序，減少主資料庫 I/O
MAXDOP = N	指定最大並行度 (parallelism)
*/
-- 重建單一索引
ALTER INDEX 此Table的Index名稱
ON Table名稱
REBUILD;

-- 重建整個資料表的所有索引
ALTER INDEX ALL
ON Table名稱
REBUILD;

-- 指定選項：線上重建、填充因子 80
ALTER INDEX ALL
ON Table名稱
REBUILD WITH (ONLINE = ON, FILLFACTOR = 80);

