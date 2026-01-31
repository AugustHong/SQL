
/*
參考網圵： http://www.blueshop.com.tw/board/FUM20041006152735ZFS/BRD200906201850586G6.html

(1)備份：
BACKUP DATABASE {DB_NAME} TO DISK = N'{BAK_PATH}' WITH NOFORMAT, INIT, NAME = N'{DB_NAME}', SKIP, NOREWIND, NOUNLOAD, STATS = 10, CHECKSUM
GO

=> 例： BACKUP DATABASE [master] TO DISK = N'C:\WaterLike\DB\master.bak' WITH NOFORMAT, INIT, NAME = N'master', SKIP, NOREWIND, NOUNLOAD, STATS = 10, CHECKSUM
GO


(2)還原：
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'{DB_NAME}' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'{DB_NAME}' )
if @backupSetId is null begin raiserror(N'確認失敗。找不到資料庫 ''{DB_NAME}'' 的備份資訊。', 16, 1) end
RESTORE VERIFYONLY FROM DISK = N'{BAK_PATH}' WITH FILE = @backupSetId, NOUNLOAD, NOREWIND
GO

=> 例： declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'master' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'master' )
if @backupSetId is null begin raiserror(N'確認失敗。找不到資料庫 ''master'' 的備份資訊。', 16, 1) end
RESTORE VERIFYONLY FROM DISK = N'C:\WaterLike\DB\master.bak' WITH FILE = @backupSetId, NOUNLOAD, NOREWIND
GO
*/