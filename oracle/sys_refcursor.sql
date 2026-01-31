-- 系統游標  (建立SP時)
create or replace function SYS_REF RETURN sys_refcursor
is

 rc sys_refcursor;
begin

  open rc for select *  from TableA;
  -- 不能在這邊關閉，在實際用到實才關閉
  return rc;
 
end SYS_REF;
/

-- 使用時
create or replace procedure SYS_REF_SP is
  refc sys_refcursor;
  v_id TableA.ID%TYPE;
  v_name TableA.NAME%TYPE;
begin
  -- 取得
  refc := SYS_REF();

  -- 使用
  LOOP
    FETCH refc INTO v_id, v_name;
      -- TODO:
    EXIT WHEN refc%NOTFOUND;
  END LOOP;
end;

