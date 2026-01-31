-- 以下皆是假設 要連 [192.168.0.1], 目標的 DB Name = TestDB

/*
    第一步： 建立 DB-LINK
*/
-- 建立 Linked Server
EXEC sp_addlinkedserver 
    @server = '192.168.0.1',               -- 自訂的 Linked Server 名稱 (方便的話就使用IP最快)
    @srvproduct = '',                       -- 可留空
    @provider = 'SQLNCLI',                  -- SQL Native Client
    @datasrc = '192.168.0.1';               -- 遠端 SQL Server 的 IP

-- 設定登入資訊
EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = '192.168.0.1',           -- 上面設定的 Linked Server 名稱
    @useself = 'false',                     -- 不使用本地登入
    @locallogin = NULL,                     -- 所有本地使用者都使用此登入
    @rmtuser = 'remote_user',               -- 遠端 SQL Server 的登入帳號
    @rmtpassword = 'remote_password';       -- 遠端 SQL Server 的密碼

-------------------------------------------------------------------------------------

/*
    第二步： 加入 RPC 的設定，可先不加若出現錯誤是 RPC相關的再執行
*/
EXEC sp_serveroption '192.168.0.1', 'rpc', true;
EXEC sp_serveroption '192.168.0.1', 'rpc out', true;

-------------------------------------------------------------------------------------

-- 查詢 Table
SELECT * FROM [192.168.0.1].[TestDB].[dbo].[TestTable];

/*
    說明： OPENQUERY 的裡面 不能下 T-SQL！！ 後面常看到這個會有限制！！
    說明： 但不管哪個 Table 和 Function 和 SP 的權限都要確定這個登入帳戶是可以使用的！！！！ (很重要！！)
*/

/*
    呼叫 Function，有幾種寫法請依狀況測試 (因為有些情況下某些能用，某些不能用)
*/
-- 方法一
declare @result bit;
EXECUTE ('SELECT @result = [TestDB].[dbo].[TestFunction](''ABC'') AS Result') AT [192.168.0.1];
select @result;

-- 方法二
SELECT * 
FROM OPENQUERY([192.168.0.1], '[TestDB].[dbo].[TestFunction](''ABC'') AS Result');

-- 方法三： 動態參數
DECLARE @InputParam VARCHAR(20), @OutputParam BIT;
DECLARE @RunSql nvarchar(1000) = 'SELECT @OutputParam = Result FROM OPENQUERY([192.168.0.1], ''SELECT [TestDB].[dbo].[TestFunction](''''' + @InputParam + ''''') AS Result'')';
EXEC sp_executesql @RunSql, N'@OutputParam BIT OUTPUT', @OutputParam OUTPUT;
SELECT @InputParam, @OutputParam;

/*
    呼叫 SP： SP裡面有分為 參數裡有 OUTPUT ， 或者 SP 裡面是用 SELECT 回傳的
              一樣都要試試能不能用，不行就改用別的試試
*/
-- 方法一： 有開通權限的話可以直接使用
DECLARE @result INT;
EXEC [192.168.0.1].[TestDB].[dbo].[TestSP] 'ABC', @result OUTPUT;

-- 方法二： 有OUTPUT參數的
DECLARE @result INT;
EXECUTE ('EXEC [TestDB].[dbo].[TestSP] ''ABC'', @result OUTPUT') AT [192.168.0.1];
select @result;

-- 方法三： SP裡面是用SELECT出來的 
EXECUTE OPENQUERY([192.168.0.1], 'EXEC [TestDB].[dbo].[TestSP] ''ABC''');



