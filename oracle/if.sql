create or replace function TEST_COUNT(P_R IN NUMBER, P_A IN TableA%rowtype)  --也可傳入 Table型別過來
  return NUMBER is

  FunctionResult NUMBER;

  V_V VARCHAR2(200);
  V_N NUMBER;
  V_D DATE;
  V_B BOOLEAN := FALSE;
  V_C CLOB;
begin

  IF (P_R > 10) THEN
    FunctionResult := 10;
  ELSE
    FunctionResult := 0;
  END IF;

  IF P_R IS NOT NULL THEN
    -- TODO
  END IF;

  IF P_R IN (1, 2, 3) THEN
    -- TODO
  END IF;

  IF EXISTS(SELECT 1 FROM TableA WHERE ID = P_R) THEN
    -- TODO
  END IF;

  -- 使用 Table型別
  IF P_A.ID = 1 THEN

  END IF;

  RETURN FunctionResult;

end TEST_COUNT;
/

