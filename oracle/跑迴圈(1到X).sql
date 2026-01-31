create or replace function GET_COUNT(P_NAME VARCHAR) return varchar2 is

  V_NUM NUMBER;
  V_CODE VARCHAR2(1);
begin
  -- 跑 1 到 傳入的字串長度 (也可用 1..99 就是跑 1到 99)
  FOR V_NUM IN 1..LENGTH(P_NAME) LOOP
    V_CODE := SUBSTR(P_NAME, V_NUM, 1);
  END LOOP;

  RETURN NULL;
end GET_COUNT;