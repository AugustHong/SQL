-- 讀取 XML
create or replace procedure READ_XML(data varchar2) is

   -- 轉成 XML格式
   pxml_data xmltype := xmltype(data);
   --'<ROOT><EMP>A1</EMP>
   --       <ROW><PROC_TYPE>1</PROC_TYPE><NO>112</NO><EMP>A1</EMP></ROW>
   --       <ROW><PROC_TYPE>2</PROC_TYPE><NO>113</NO><EMP>A2</EMP></ROW>
   -- </ROOT>'

   cursor c1 is
        SELECT  ExtractValue(Value(p),'/ROOT/EMP/text()')  EMP ,  --取到 A1
                ExtractValue(Value(p1),'/ROW/PROC_TYPE/text()')  proc_type,  -- 1 和 2
                ExtractValue(Value(p1),'/ROW/NO/text()')  no,  -- 112 和 113
                ExtractValue(Value(p1),'/ROW/EMP/text()')  rEmp -- A1 和 A2
           FROM TABLE(XMLSequence(Extract(pxml_data,'/ROOT'))) p,
                TABLE(XMLSequence(Extract(pxml_data,'/ROOT/ROW'))) p1;
begin
   for r in c1 loop
      -- Todo
   end loop;
end;
/

