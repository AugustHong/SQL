/* 和 MSSQL 差不多*/

MERGE INTO TableA A  --要被修改的
      USING (SELECT * FROM TableB) B ON (A.ID = B.ID)
      WHEN MATCHED THEN
        UPDATE
           SET NAME = B.NAME
      WHEN NOT MATCHED THEN
        INSERT
          (ID,
           NAME)
        VALUES
          (B.ID,
           B.NAME);