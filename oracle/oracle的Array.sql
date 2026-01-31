--參考網圵： https://tomkuo139.blogspot.com/2015/04/oracle-plsql-array.html

/*
table of 陣列
語法: [Create or replace] Type typeName is Table of DataType [index by BINARY_INTEGER];

若是用 create type, 則不能加 index by BINARY_INTEGER.

若沒有加 index by BINARY_INTEGER, 則設定資料前, 須先有兩個動作 :
● 初始化, 即 變數名稱 typeName := typeName( );, 否則會有錯誤: ORA-06531: Reference to uninitialized collection.
● 指定陣列大小, 即 變數名稱.extend( arraySize );, 否則會有錯誤: ORA-06533: Subscript beyond count.
*/

/*
varray of 陣列
語法: [Create or replace] Type typeName is varray( arraySize1 ) of DataType;

設定資料前, 須先有兩個動作 :
● 初始化, 即 變數名稱 typeName := typeName( );, 否則會有錯誤: ORA-06531: Reference to uninitialized collection.
● 指定陣列大小, 即 變數名稱.extend( arraySize2 );, 且 arraySize2 <= arraySize1, 否則會有錯誤: ORA-06533: Subscript beyond count.
*/

/*
一維 array 相關函數
● 指定陣列大小: 變數名稱.extend( arraySize )

● 總筆數: 變數名稱.count

● 絕對位置第 n 筆的資料: 變數名稱( n )

● 相對位置第 n 筆的資料: 變數名稱.next( n )

● 第 1 筆資料: 變數名稱.first

● 最後 1 筆資料: 變數名稱.last

● 刪除第 n 筆資料: 變數名稱.delete( n )

● 刪除全部資料: 變數名稱.delete

● 第 n 筆的 Record 資料型態的『某欄位的資料』: 變數名稱( n ).ColumnName_of_Record

● 第 n 筆的 Record 資料型態的『某欄位陣列的第 m 個資料』: 變數名稱( n ).ColumnName_of_Record( m )
*/

/*
二維 array 相關函數
● 指定某列陣列大小: 變數名稱(i).extend( arraySize )

● 總筆數: 變數名稱.count

● 某列陣列 - 筆數: 變數名稱(i).count

● 某列陣列 - 絕對位置第 n 筆的資料: 變數名稱(i)( n )

● 某列陣列 - 相對位置第 n 筆的資料: 變數名稱(i).next( n )

● 某列陣列 - 第 1 筆資料: 變數名稱(i).first

● 某列陣列 - 最後 1 筆資料: 變數名稱(i).last

● 某列陣列 - 刪除第 n 筆資料: 名稱(i).delete( n )

● 刪除全部資料: 變數名稱.delete

● 某列陣列 - 刪除全部資料: 變數名稱(i).delete

● 某列陣列 - 第 n 筆的 Record 資料型態的『某欄位的資料』: 變數名稱(i)( n ).ColumnName_of_Record

● 某列陣列 - 第 n 筆的 Record 資料型態的『某欄位陣列的第 m 個資料』: 變數名稱(i)( n ).ColumnName_of_Record( m )
*/

/*
注意事項
● Type 變數若是宣告在 Package 內, 被其他 Procedure / Package 使用時, 不能做為 "動態 SQL" 的參數.

● Type 變數若是用 Create Type 建立, 被其他 Procedure / Package 使用時, 可以做為 "動態 SQL" 的參數.

● Type 變數若是用 Create Type 建立, 且要給其他 Owner 使用時, 則必須 Grant EXECUTE 權限給 Owner.
*/

--Non Create Type 範例
declare
  type tom_array is table of varchar2(10) index by BINARY_INTEGER;
  aa   tom_array;
begin
  -- 直接設定 array 資料值
  aa(1) := '1';
  aa(2) := '2';
  aa(3) := 'a';
  
  dbms_output.put_line( 'Count : ' || aa.count );
  
  for i in 1..aa.count loop
    dbms_output.put_line( aa(i) );
  end loop;
end;

--Create Type 範例
-- 1.建立 array Type
create or replace type tom_array is table of varchar2(10);

-- 2.設定 array 資料值 (要設定資料, 必須先初始化, 然後指定陣列大小)
declare
  aa tom_array := tom_array();  -- 初始化
begin
  -- 設定陣列大小
  aa.extend(3);
  
  -- 設定陣列值
  aa(1) := 'a';
  aa(2) := 'b';
  aa(3) := 'c';
  
  dbms_output.put_line( aa.count );
  dbms_output.put_line( aa(1) );
  dbms_output.put_line( aa(2) );
  dbms_output.put_line( aa(3) );
  
  -- 刪除陣列資料
  aa.delete;
  
  aa.extend(2);  -- 必須在重新 extend 指定大小
  aa(1) := 'x';
  aa(2) := 'y';
  dbms_output.put_line( aa.count );
  dbms_output.put_line( aa(1) );
  dbms_output.put_line( aa(2) );
end;