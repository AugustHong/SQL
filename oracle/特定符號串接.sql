/* 用逗號串接， 有2種方法 第1種是較舊的； 第2個較新(但有時候遇到版本不夠的還是要用舊的)*/

-- 版本較低的
SELECT T.C
-- 只能用 , 串接 (無法指定要的符號)  就是  TO_CHAR(wm_concat(字串))
FROM (SELECT K.X, TO_CHAR(wm_concat(K.C)) AS C
    FROM (SELECT 1 AS X, NAME AS C    -- 1 是因為要把他們合併, NAME 就是你要合併的字串欄位
          FROM TableA
          WHERE ID <= 20   --可再加上條件去篩選
          --GROUP BY     如果有要GROUP BY 的可以再加
        ) K
    GROUP BY K.X) T;


-- 較新的版本