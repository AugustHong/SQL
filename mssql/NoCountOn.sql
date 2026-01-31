-- 參考網址： https://ithelp.ithome.com.tw/articles/10198514

-- 可以加在 T-SQL 或 SP裡面
/*
    用途：
    1. 不回傳受影響的資料列(可節省網路傳輸),通常如果沒有要看的話,會寫不回傳,又能節省網路傳輸)
    2. 雖然不回傳,但不影響@@ROWCOUNT,所以如果想知道影響的資料列,還是能用@@ROWCOUNT來讀取
*/


/*
    範例一：沒加這個的
    會出現：
    (2個資料列受到影響)
    (1個資料列受到影響)
*/
select 1 union select 1111
select c1=@@ROWCOUNT 

/*
    範例一：加這個的
    會出現：
    (命令己執行完成)
*/
SET NOCOUNT ON;
select 1 union select 1111
select c1=@@ROWCOUNT

-- 要關閉就 SET NOCOUNT OFF;
-- 預設就是 OFF
