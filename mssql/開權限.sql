-- 參考網址：https://learn.microsoft.com/zh-tw/sql/t-sql/statements/grant-system-object-permissions-transact-sql?view=sql-server-ver16

-- 增加 Function、SP執行權限給別人
GRANT EXECUTE ON dbo.TEST_FUNCTION TO test01;