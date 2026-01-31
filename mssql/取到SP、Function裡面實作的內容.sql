-- 參考網址： https://blog.darkthread.net/blog/dump-sql-things/
-- 取到 MSSQL 的 SP、FUnction 裡面的實作SQL內容

select m.object_id,m.definition,o.name,o.type, o.type_desc
from sys.sql_modules m join sys.objects o
on m.object_id = o.object_id
where o.type in ('V','FN','IF','P')
and o.is_ms_shipped = 0