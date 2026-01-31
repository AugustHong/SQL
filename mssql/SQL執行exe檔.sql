/*
SQL 執行 exe 檔：

參考網圵：
https://www.itread01.com/article/1471424914.html
http://dotblogs.com.tw/chou/2011/01/09/20691

步驟：
1. 先開啟xp_cmdshell
       有2種方法可以開啟：
       (a) 按 資料庫連結/右鍵/Facet ， 再把 XPCmdShellEnabled 的值改成 True
       (b) 用語法：
       -- 開啟 xp_cmdshell
       EXEC sp_configure 'show advanced options', 1;
       RECONFIGURE;
        EXEC sp_configure 'xp_cmdshell', 1;
       RECONFIGURE;

      -- 關閉 xp_cmdshell
      EXEC sp_configure 'show advanced options', 1;
      RECONFIGURE;
      EXEC sp_configure 'xp_cmdshell', 0;
      RECONFIGURE;

2. 輸入指令
Exec xp_cmdshell 'C:\Users\green\Desktop\TK\TK\bin\Debug\TK.exe'  (後面的 exe 改成你要跑的 exe 絕對路徑)

*** 你要執行的 exe 的母路徑 (即 TK 資料夾 要加上權限)
作法：
(a) 點你的 TK 資料夾 / 右鍵 / 內容 / 安全性 /進階/  新增
(b) 按下 "選取一個主體"
(c) 輸入 service ， 並按下 "檢查名稱" ， 再按下 確定
(d) 基本權限 給他基本的就行
(e) 全部 套用 + 確定 即可

3. 注意事項
     (a) 可能會出現如上【呼叫exe檔案（但是執行exe檔案，總一直顯示“正在執行查詢”）】的問題，那是因為，exe程式不是【自動執行】和【自動退出】這兩點很重要。

     (b) xp_deletemail 的執行許可權預設授予 sysadmin 固定伺服器角色的成員，但可以授予其他使用者

     (c) xp_cmdshell 以同步方式操作。在命令列直譯器命令執行完畢之前，不會返回控制。

     (d) 不能執行使用者互動的命令,比如,執行記事本這種需要使用者錄入,關閉等操作的程式,就會掛死程式

      (e) 如果程式是要彈出使用者介面的,使用者介面不會彈出
*/