--網圵：https://sites.google.com/site/yutingnote/sql/mssqlqudedinbiziliao

--範例：
 select *
     from 資料表名稱
     order by 欄位
     offset 5 row                                 /*跳過5筆*/
     fetch next 10 rows only                /*抓10筆*/