CREATE OR REPLACE FUNCTION RunSqlInto () VARCHAR2 IS
      
      VAR_NAME VARCHAR2(100) := 'ABC';
      V_CNT           NUMBER(5);
      V_SQL           VARCHAR2(1000);         
   BEGIN
      
      V_SQL := ' SELECT COUNT(*) CNT 
                   FROM TableA D
                  WHERE D.NAME = ''' || VAR_NAME || '''';           
      EXECUTE IMMEDIATE V_SQL INTO V_CNT;
      
      RETURN TO_CHAR(V_CNT);
  END RunSqlInto;