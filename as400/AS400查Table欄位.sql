/*
官網:
https://community.ibm.com/community/user/datamanagement/blogs/lynn-chou/2018/10/01/the-sql-reference-for-cross-platform-development

文件:
https://www.ibm.com/docs/en/ssw_ibm_i_72/db2/rbafzpdf.pdf?origURL=ssw_ibm_i_72/db2/rbafzpdf.pdf
*/

-- AS400 (DB2) 查出 所有Table 結構
SELECT * FROM QSYS2.SYSTABLES WHERE TABLE_NAME= '<table_name>';

-- 查欄位細節
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, LENGTH, NUMERIC_SCALE, COLUMN_TEXT, COLUMN_DEFAULT, IS_IDENTITY FROM QSYS2.SYSCOLUMNS 
WHERE TABLE_SCHEMA = 'SEKGIF' AND TABLE_NAME='<table_name>';