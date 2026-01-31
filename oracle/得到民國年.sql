create or replace function GET_EEE_DATE(P_DATE in date, P_FORMAT in varchar2) return varchar2 is
  FunctionResult varchar2(30);
begin
  
  BEGIN
   
     SELECT 
       TRIM(
         TO_CHAR((TO_CHAR(P_DATE,'YYYY')-1911),'099') ||
         (TO_CHAR(P_DATE, P_FORMAT))
       ) as D
     into FunctionResult
     from dual;  
    
  EXCEPTION
    WHEN OTHERS THEN
      FunctionResult := GET_EEE_DATE(SYSDATE, 'MM/DD HH:mi:ss');
  END;

  return(FunctionResult);
end GET_EEE_DATE;
/
