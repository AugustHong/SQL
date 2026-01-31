create or replace function UPDATE_FUNC
  RETURN number is

  -- Function平常是不能做異動的，要的話要加入下面那一行就行
  PRAGMA AUTONOMOUS_TRANSACTION;
begin
  UPDATE TableA 
  SET A.NAME = 'ABC'
  WHERE A.ID = 1;
end;