create or replace function RunCmd(cmd_string  in varchar2) return number

   /*
   請先開立權限， 底下所有的Abc 都是指登入 Oracle 的角色喔
   DBMS_JAVA.grant_permission('ABC','SYS:java.lang.RuntimePermisssion', 'writeFileDescriptor', '');  --寫檔權限
   DBMS_JAVA.grant_permission('ABC','SYS:java.lang.RuntimePermisssion', 'readFileDescriptor', '');   --讀檔權限
   DBMS_JAVA.grant_permission('ABC','SYS:java.io.FilePermission', '執行路徑：例如 d://test/*', 'execute');  --執行權限
   
   目前都好像只能配合Java，之後再查有沒有別的方法
   */

  as
   language java
  name 'OracleAbc.RunThis(java.lang.String) return integer';