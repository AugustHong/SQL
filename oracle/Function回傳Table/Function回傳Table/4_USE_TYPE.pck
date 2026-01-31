create or replace package USE_TYPE is

  FUNCTION USE(P_DATE IN VARCHAR2) RETURN TABLE_TYPE_TEST;

end create or replace package USE_TYPE is;
/
create or replace package body USE_TYPE is

  FUNCTION USE(P_DATE IN VARCHAR2) RETURN TABLE_TYPE_TEST IS
  
    -- 宣告 TYPE 初始型別
    W_TB            TABLE_TYPE_TEST := NEW TABLE_TYPE_TEST();
    R_TB            TABLE_TYPE_ROW := TABLE_TYPE_ROW(null, null);
    V_ROW           NUMBER := 0;
    V_DATE          DATE;
  
  BEGIN
    -- 這邊是迴圈在跑，但不會成功，因為少了函式
    FOR RD IN RUN(V_DATE) LOOP
      V_ROW := V_ROW + 1;
      W_TB.EXTEND;
    
      R_TB.A    := RD.A;
      R_TB.B     := RD.B;
    
      W_TB(V_ROW) := R_TB;
    END LOOP;

    RETURN W_TB;
  END;
/
