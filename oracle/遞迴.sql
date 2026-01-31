--網址： https://dotblogs.com.tw/programer_never_sleeps/2020/02/05/oracle-recursion-connection-by
          SELECT ID
               , NAME
               , LEVEL
            FROM TABLE
      START WITH ID   = '指定ID'              --遞迴搜尋的[起點]
CONNECT BY PRIOR PARENT_ID = ID     --以CONNECT BY 定義主從關係，父項欄位前要加上PRIOR