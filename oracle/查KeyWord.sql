--查所有資料

select *
from ALL_SOURCE
where OWNER = 'DB名稱' AND
(lower(TEXT) LIKE '%要查的KeyWord1%' or
 lower(TEXT) LIKE '%要查的KeyWord2%')
 order by NAME, TYPE, LINE

-----------------------------------------------------------

--查 Table 的所有欄位
select * from all_col_comments t
where t.OWNER = 'DB名稱'
AND   t.table_name = 'Table名稱';

--在使用 where 條件 查關鍵字時，注意 使用 lower() 函式來查 (英文的話)， 因為大小寫 的 like 查法有點怪
/*
   例：
      select * from all_col_comments t
      where t.OWNER = 'DB名稱'
       AND   t.table_name = 'Table名稱'
	   AND lower(t.colnum_name) like '%aaa%'
*/

------------------------------------------------------------

--查出所有 TABLE (外加 Table 中文Comment，放在 all_tab_comments 這張裡面)
select * from ALL_ALL_TABLES t
inner join all_tab_comments c 
   on t.table_name = c.table_name
   AND t.owner = c.owner
where t.owner = 'DB名稱'  --要改成自己的 DB 
order by t.table_name

-------------------------------------------------------------

--查出所有 View
SELECT *
FROM all_views v
where v.OWNER = 'DB名稱'
AND   v.view_name = 'VIEW 名稱';


---------------------------------------------------------------

-- 所有資料表 欄位詳細資料
--資料表及欄位型別、長度、精準位數、NULLABLE、預設值
SELECT
  C.OWNER, C.TABLE_NAME, C.COLUMN_ID, C.COLUMN_NAME, 
  DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_DEFAULT, 
  NULLABLE, COMMENTS
FROM
  ALL_TAB_COLUMNS C 
JOIN ALL_TABLES T ON 
  C.OWNER = T.OWNER AND C.TABLE_NAME = T.TABLE_NAME
LEFT JOIN ALL_COL_COMMENTS R ON
  C.OWNER = R.Owner AND 
  C.TABLE_NAME = R.TABLE_NAME AND 
  C.COLUMN_NAME = R.COLUMN_NAME
WHERE  
  C.OWNER  = 'DB名稱'
ORDER BY C.TABLE_NAME, C.COLUMN_ID

-----------------------------------------------------------------

--取得所有索引資料
--依資料表名稱、索引名稱、欄位順序、欄位名稱、排序方向(ASC/DESC)列出所有索引項目
SELECT 
  I.TABLE_OWNER, I.TABLE_NAME, I.INDEX_NAME, I.INDEX_TYPE,
  I.UNIQUENESS, C.COLUMN_POSITION, C.COLUMN_NAME, C.DESCEND
FROM 
  ALL_INDEXES I JOIN ALL_IND_COLUMNS C
ON 
  I.TABLE_OWNER = C.TABLE_OWNER AND
  I.INDEX_NAME = C.INDEX_NAME
WHERE
  C.TABLE_OWNER = 'DB名稱'
ORDER BY I.TABLE_NAME, I.INDEX_NAME, COLUMN_POSITION

--------------------------------------------------------------------------

--取得主鍵值(Primary Key) 和 外鍵值(FK)欄位
SELECT 
  C.OWNER, C.TABLE_NAME, D.POSITION, D.COLUMN_NAME , A.COMMENTS, 
  case C.CONSTRAINT_TYPE
     when 'P' then 'PK'
	 when 'R' then 'FK'
	else '' end as Key_TYPE, C.INVALID
	-- FK 的 Table
   , (
     select distinct FK_C.TABLE_NAME
     from ALL_CONSTRAINTS FK_C
     where FK_C.CONSTRAINT_NAME = C.R_CONSTRAINT_NAME
   ) as R_TABLE_NAME
FROM 
  ALL_CONSTRAINTS C 
  INNER JOIN ALL_CONS_COLUMNS D ON
  C.OWNER = D.OWNER AND
  C.CONSTRAINT_NAME = D.CONSTRAINT_NAME
  
  INNER JOIN all_col_comments A ON
  C.OWNER = A.OWNER AND
  C.TABLE_NAME = A.TABLE_NAME AND
  D.COLUMN_NAME = A.COLUMN_NAME
WHERE
  C.CONSTRAINT_TYPE in ('P', 'R') AND C.OWNER = 'DB名稱'
ORDER BY C.TABLE_NAME, C.CONSTRAINT_TYPE, D.POSITION


--要查哪個索引有錯
select * from SYS.ALL_CONSTRAINTS t
where t.CONSTRAINT_NAME like '%錯誤代碼%';

-----------------------------------------------------------------------------

--所有有 Partition 的表
select * from ALL_PART_KEY_COLUMNS P
where P.Owner = 'DB名稱' AND P.OBJECT_TYPE = 'TABLE'

-- 所有的 Partition 資料
select distinct
I.TABLE_NAME, P.COLUMN_NAME, P.COLUMN_POSITION,
PD.Partition_Name, PD.COMPOSITE, 
PD.STATUS, PD.LOGGING, PD.COMPRESSION, PD.blevel, PD.GLOBAL_STATS, PD.INTERVAL, PD.SEGMENT_CREATED
from ALL_PART_KEY_COLUMNS P
inner join ALL_IND_PARTITIONS PD 
ON P.OWNER = PD.Index_Owner AND P.name = PD.INDEX_NAME
inner join ALL_INDEXES I
ON PD.INDEX_NAME = I.INDEX_NAME
where P.Owner = 'DB名稱' AND I.TABLE_NAME = '要查的資料表'
ORDER BY I.TABLE_NAME, PD.PARTITION_NAME

-------------------------------------------------------------------------------

--取得每個表最新被異動(不是資料異動，是表被修改)的時間
select *
  from (select uat.table_name as TABLE_NAME,
               uat.num_rows as TABLE_CURRENT_TOTAL_ROWS_NUM,
               (select MAX(last_ddl_time)
                  from user_objects
                 where object_name = uat.table_name) as LAST_UPDATE_TIME
          from user_all_tables uat) t
 order by LAST_UPDATE_TIME desc
 
 ----------------------------------------------------------------------------------
 
 --查詢所有序號
 select * from user_sequences;
 
 --------------------------------------------------------------------------------------
 
 --查資料表使用的大小
 Select Segment_Name, TO_CHAR(Sum(bytes)/1024/1024) || 'MB' AS COST_MB 
 From User_Extents 
 Group By Segment_Name 
 having Segment_Name = '資料表名稱';
 
 ---------------------------------------------------------------------------------------
 
 --取出 1 - 9999
 SELECT LEVEL NUM_LIST FROM DUAL CONNECT BY LEVEL <= 9999
 
 --------------------------------------------------------------------------------------
 
 -- 先取亂數
    SELECT LPAD( CEIL( dbms_random.value * 1000 ), 3, '0' ) INTO V_RAND FROM DUAL;
	
-----------------------------------------------------------------------------------------

-- 查Table 權限誰開的/誰有的
select
p.GRANTEE as 被開權限者,
p.OWNER as Obj擁有者,
p.TABLE_NAME as Obj,
p.GRANTOR as 開立權限者,
p.privilege as 開立執行權限,
p.GRANTABLE,
p.HIERARCHY
from user_tab_privs p;

------------------------------------------

revoke select on NP_PRD_IMG from PIC;

---------------------------------------------

ROW_NUMBER() OVER(PARTITION BY 分類欄位 ORDER BY 排序欄位)

------------------------------------------------------------------------------------

 -- 查詢別名
 select * from all_synonyms t
 where t.SYNONYM_NAME like 'DB名稱%';
 
---------------------------------------------------------------------------------------

-- 備份 TABLE
create table {新Table名} as select * from {Table名} {Where條件(可加可不加)}