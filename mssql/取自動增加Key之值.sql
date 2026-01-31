/* 因為 MSSQL 有自動增長的Key 值，故如需要得到剛才新增的ID為何以用下方法：
   參考網址： https://learn.microsoft.com/zh-tw/dotnet/framework/data/adonet/retrieving-identity-or-autonumber-values
*/

-- 方法一：@@IDENTITY  (包含目前工作階段 (Session) 中於任何資料表內產生的最後一個識別值。 @@IDENTITY 可能會受到觸發程序 (Trigger) 的影響，而且可能無法傳回您所預期的識別值。)
insert into TableA (C1) values ('測試A');
select @@IDENTITY;

-- 方法二：SCOPE_IDENTITY函式 (傳回目前執行範圍內的最後一個識別值。 建議您針對大部分案例使用 SCOPE_IDENTITY)
insert into TableA (C1) values ('測試C');
select SCOPE_IDENTITY()

-- 方法三：IDENT_CURRENT函式 (傳回在任何工作階段和任何範圍中針對特定資料表所產生的最後一個識別值。)
insert into TableA (C1) values ('測試D');
select IDENT_CURRENT('TableA')

-- 方法四： INSERT 時 OUTPUT (其中 TableA.ID 是自動增加 的話 就可以這樣用 OUTPUT出來)
INSERT INTO TableA (C1) OUTPUT Inserted.ID VALUES ('測試1');
