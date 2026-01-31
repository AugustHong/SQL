/* 讀取 TXT 並寫入Table*/

/*
    TXT格式： (TableA 共有 3欄) 的話
    A,B,C
    D,E,F
    G,H,I
*/

/*
    如果遇到  由於無法開啟檔案。。。，無法進行大量載入。作業系統錯誤碼為5（拒絕訪問)
    解決方法：更改SQL SERVER服務的登入身份為系統管理員或其他有許可權訪問的賬戶。
            （1）開啟SQL SERVER configuration managaer，點選SQL SERVER服務
            （2）在彈出的對話方塊，修改登入身份為“本地帳戶”，輸入一個有許可權訪問遠程網路檔案的使用者。
            （3）重啟服務即可。

            或者執行時就使用本地帳戶去執行 (就是不用驗證的那個) -> 但實際開發時就要想要如何處理
*/

-- 讀取檔案 (純讀檔的話就，建1張表 然後全部讀取)
CREATE TABLE ##T(EMAIL NVARCHAR(2000));
--讀入
BULK INSERT ##T FROM N'C:\Users\user\Desktop\test.txt';
SELECT * FROM ##T;
--刪除暫存表
DROP TABLE ##T;

-- 讀取並寫入 (檔案要寫實體路徑)
CREATE TABLE TmpTestTable
(
    Char1 varchar(10),
    Char2 varchar(10),
    Char3 varchar(10)
);

BULK INSERT TmpTestTable  FROM 'C:\Users\user\Desktop\test.txt'  
   WITH (
      DATAFILETYPE = 'char',  --欄位定義為char
      FIELDTERMINATOR = ',', --用逗號作為分隔
      ROWTERMINATOR = '\n'　　-- ROWTERMINATOR = '\n' (指定資料列結束字元為新行字元)
);
SELECT * FROM TmpTestTable;
DROP TABLE TmpTestTable;  -- 因為這邊是測試用所以才Drop，不然平常就寫入洗到主檔就行
