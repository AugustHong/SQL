/*
P_FORMAT
{EEE} = チ瓣 (3絏)
{MM} ,  {M} = る ( {MM} 干2絏)
{DD} ,  {D} = ら ( {DD} 干2絏) 
{HH} ,  {H} =  ( {HH} 干2絏)
{mm} ,  {m} = だ ( {mm} 干2絏)
{ss} ,  {s} =  ( {ss} 干2絏) 
*/
create or replace function GET_EEE_DATE(P_DATE in date, P_FORMAT in varchar2) return varchar2 is
  FunctionResult varchar2(300);
  
  V_EEE NUMBER;
  V_MM NUMBER;
  V_DD NUMBER;
  V_HH NUMBER;
  V_mi NUMBER;
  V_ss NUMBER;
begin
  
  BEGIN
   
     --  逆
     SELECT
      (TO_NUMBER(TO_CHAR(P_DATE, 'YYYY')) - 1911 ) AS EEE,
      TO_NUMBER(TO_CHAR(P_DATE, 'MM')) AS MM,
      TO_NUMBER(TO_CHAR(P_DATE, 'DD')) AS DD,
      TO_NUMBER(TO_CHAR(P_DATE, 'HH24')) AS HH,
      TO_NUMBER(TO_CHAR(P_DATE, 'mi')) AS mi,
      TO_NUMBER(TO_CHAR(P_DATE, 'ss')) AS ss
      
      INTO V_EEE,
           V_MM,
           V_DD,
           V_HH,
           V_mi,
           V_ss
           
     FROM DUAL;
     
     -- 倒﹚戈
     FunctionResult := P_FORMAT;
     
     -- 秨﹍
     FunctionResult := REPLACE(FunctionResult, '{EEE}', TO_CHAR(V_EEE));
     FunctionResult := REPLACE(FunctionResult, '{MM}', LPAD(TO_CHAR(V_MM), 2, '0'));
     FunctionResult := REPLACE(FunctionResult, '{M}', TO_CHAR(V_MM));
     FunctionResult := REPLACE(FunctionResult, '{DD}', LPAD(TO_CHAR(V_DD), 2, '0'));
     FunctionResult := REPLACE(FunctionResult, '{D}', TO_CHAR(V_DD));
     FunctionResult := REPLACE(FunctionResult, '{HH}', LPAD(TO_CHAR(V_HH), 2, '0'));
     FunctionResult := REPLACE(FunctionResult, '{H}', TO_CHAR(V_HH));
     FunctionResult := REPLACE(FunctionResult, '{mm}', LPAD(TO_CHAR(V_mi), 2, '0'));
     FunctionResult := REPLACE(FunctionResult, '{m}', TO_CHAR(V_mi));
     FunctionResult := REPLACE(FunctionResult, '{ss}', LPAD(TO_CHAR(V_ss), 2, '0'));
     FunctionResult := REPLACE(FunctionResult, '{s}', TO_CHAR(V_ss));
    
  EXCEPTION
    WHEN OTHERS THEN
      FunctionResult := GET_EEE_DATE(SYSDATE, 'MM/DD HH:mi:ss');
  END;

  return(FunctionResult);
end GET_EEE_DATE;
/
