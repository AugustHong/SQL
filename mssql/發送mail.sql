-- 備註： 需先設定 相關設定作業後方可使用

/*
EXEC msdb.dbo.sp_send_dbmail @profile_name='剛才設定的設定檔名稱(test)',   
                                      @recipients='要傳送的Mail目標位置(多筆中間用;隔開)',  
                                      @subject='主旨',  
                                      @body='Mail內容',  
                                      @body_format='text' -- 設定格式，用text就行
                                      @copy_recipients = '副本收件人 (CC)(多筆中間用;隔開)'
                                      @blind_copy_recipients= '密件副本收件人 (BCC)(多筆中間用;隔開)'
*/

EXEC msdb.dbo.sp_send_dbmail @profile_name='test',   
                                      @recipients='abc@gmail.com.tw;def@gmail.com',  
                                      @subject='這是主旨',  
                                      @body='這是Mail的內容',  
                                      @body_format='text' -- 設定格式，用text就行
