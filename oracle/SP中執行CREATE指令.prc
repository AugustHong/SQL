create or replace procedure Test AUTHID CURRENT_USER is
begin
  -- 要在 SP 的名稱後面加上 AUTHID CURRENT_USER 即可
  execute immediate 'CREATE TABLE ABC as select * from ABC_0509';
end Test;
/
