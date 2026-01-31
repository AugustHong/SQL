/*
  Package 就是將 多個 Function 和 SP 包成一起。就可以來使用。
  以下面的例子來講：
  要呼叫 Function 就只要 TestPackage.TEST_FUNC(xxx) 即可。 SP也相同
*/

create or replace package TestPackage is

  
  function TEST_FUNC(P_CODE in varchar2) return varchar2;

  PROCEDURE TEST_SP(P_CODE      VARCHAR2,
                        O_PRICE         out NUMBER);

end TestPackage;
/

create or replace package body TestPackage is

  FUNCTION TEST_FUNC(P_CODE in varchar2) return varchar2 is
    FunctionResult varchar2(30) := '';
  begin
  
    BEGIN
    
      FunctionResult := P_CODE;
    
    EXCEPTION
      WHEN OTHERS THEN
        FunctionResult := '';
    END;
  
    return FunctionResult;
  end TEST_FUNC;

  PROCEDURE TEST_SP(P_CODE      VARCHAR2,
                        O_PRICE         out NUMBER) IS
  
    V_PRICE NUMBER(14, 2) := 0;
  
  BEGIN
  
    O_PRICE := NVL(V_PRICE, 0);
  
  END TEST_SP;

end TestPackage;
/