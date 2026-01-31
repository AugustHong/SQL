/* 這邊的作用就是 如果是NULL時給什麼值*/

-- 第1個： 如果 C1欄位是 NULL 就給 ABC
SELECT ISNULL(C1, 'ABC') FROM TableA;

-- 第2個(進階)： 可以放多個條件，如果全部都是NULL才給指定的值
-- 如果 C1 = NULL, C2 <> NULL 給 C2
-- 如果 C1 = NULL, C2 = NULL, C3 <> NULL 給 C3
-- 如果 C1 = NULL, C2 = NULL, C3 = NULL 給 ABC
SELECT COALESCE(C1, C2, C3, 'ABC') FROM TableA;