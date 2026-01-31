/* MSSQL 接收/傳送Queue*/
/*
    參考網址： https://learn.microsoft.com/zh-tw/sql/t-sql/statements/create-queue-transact-sql?view=sql-server-ver16
               https://learn.microsoft.com/zh-tw/sql/t-sql/statements/alter-queue-transact-sql?view=sql-server-ver16 
               https://learn.microsoft.com/zh-tw/sql/t-sql/statements/receive-transact-sql?view=sql-server-ver16
               https://learn.microsoft.com/zh-tw/sql/t-sql/statements/send-transact-sql?view=sql-server-ver16
*/

-- 建立 Queue
CREATE QUEUE TestQueue   --建立名為 TestQueue的Queue
    WITH STATUS=ON,  --是否 啟用
    RETENTION = ON,  --是否 訊息會保留在佇列中，直到它們所屬的交談結束為止
    ACTIVATION (
        PROCEDURE_NAME = expense_sp  --執行什麼SP
        , MAX_QUEUE_READERS = 5  --最多執行幾個儲存個體的SP
        , EXECUTE AS 'ExpenseUser' --執行SP的角色權限
    );

-- 修改 Queue
-- 設定無法啟用
ALTER QUEUE TestQueue WITH STATUS = OFF ;

-- 變更執行的SP
ALTER QUEUE TestQueue  
    WITH ACTIVATION (  
        PROCEDURE_NAME = new_expense_sp ,  
        EXECUTE AS 'SecurityAccount') ; 

-- 變更 最大預存程序執行個體數目
ALTER QUEUE TestQueue WITH ACTIVATION (MAX_QUEUE_READERS = 7) ; 

-- 接收Queue 訊息
RECEIVE conversation_handle, message_type_name, message_body  FROM TestQueue ;

-- 接收第1筆
RECEIVE TOP (1) * FROM TestQueue ;

-- 無限期等待直至收到1筆
WAITFOR (  
    RECEIVE *  
    FROM TestQueue) ;

-- 查看 Queue 中的訊息
SELECT * FROM sys.transmission_queue;

--------------------------------------------------------------------------------------------------------------------------
-- 後面送出的動作有 Message 、 Service 、 Contract   再來才是 Send (但我實在有點看不太懂，所以就先不寫了)
-- 這幾個都有關聯，但 參考網址 上寫的有點難懂又沒什麼實際的範例


