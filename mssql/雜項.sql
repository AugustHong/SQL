--宣告 Table 類型的變數
declare @TT TABLE(EventId varchar(4),TDATE INT)  --非連續日期資料表(各事件自行再定義)

--執行SP
exec SFA.dbo.PROC_LogTable  'I' ,@LOG_SP,'START' 

--寫入宣告的 Table變數
INSERT INTO @TT VALUES('E003',1)  
INSERT INTO @TT VALUES('E003',2)  

-- 同樣條件(ID)下，並排序 且只取第1筆
SELECT 	*
FROM 
(	 
	SELECT  DENSE_RANK() OVER(PARTITION BY Q.ID ORDER BY Q.NO ASC) as ROWID,*  
	FROM 
	(
		SELECT   
		A.ID,
        A.NO
		from TableA A
	) Q
) V 
WHERE V.ROWID =1  --同ID,只取第一順位的資料呈現


-- 取到 排名
SELECT ID,RANK() OVER ( ORDER BY NO) ROWNUM
FROM TableA

-- 取到 ROWNUM
SELECT ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY ID DESC ), *
FROM TableA