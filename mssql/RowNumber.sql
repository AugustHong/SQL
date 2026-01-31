/* 取同樣的資料 出現幾次(Oracle好像也有一樣的函式)*/

/*
原本的資料：
ID          NAME
----------- --------------------------------------------------
1           A
2           B
3           C
4           A
5           A
6           B
7           C
8           A
*/

-- 執行語法
SELECT *
         -- PARTITION BY [欄位] 是指用什麼來當判斷重複的條件 (這邊用 NAME)  ->多個欄位中間用 , 即可
         -- ORDER BY [欄位] 用什麼欄位排序
		,ROW_NUMBER() OVER (PARTITION BY NAME ORDER BY ID) AS rowNum
FROM TableC C;

/*
出來的結果：
ID          NAME                                               rowNum
----------- -------------------------------------------------- --------------------
1           A                                                  1
4           A                                                  2
5           A                                                  3
8           A                                                  4
2           B                                                  1
6           B                                                  2
3           C                                                  1
7           C                                                  2
*/

-- 也可以逆排
SELECT *
		,ROW_NUMBER() OVER (PARTITION BY NAME ORDER BY ID DESC) AS rowNum
FROM TableC C;

-- 找每個資料的第1個出現的
SELECT * FROM
(
	SELECT *
		,ROW_NUMBER() OVER (PARTITION BY NAME ORDER BY ID) AS rowNum
	FROM TableC C
) S
WHERE S.rowNum = 1;

/*
出來的結果：
ID          NAME                                               rowNum
----------- -------------------------------------------------- --------------------
1           A                                                  1
2           B                                                  1
3           C                                                  1
*/