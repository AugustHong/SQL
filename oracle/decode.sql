SELECT DECODE('要判斷的東西', 'A', 0, 'B', 1, 'C', 2, 3) FROM DUAL;
-- 變相版的 Case When ：上面的意思是 如果要判斷的東西 = A 給 0 ， = B 給 1， = C 給 2，反之就給 3