create or replace package PRO_HARD_WORD is

  /* 是否是難字*/
  function IS_HARD_WORD(P_WORD IN NVARCHAR2) RETURN VARCHAR2;

  /* 將 輸入文字 進行轉換 */
  function REPLACE_HARD_WORD(P_WORD IN NVARCHAR2) RETURN VARCHAR2;
  
end PRO_HARD_WORD;
/
create or replace package body PRO_HARD_WORD is

  /* 是否是難字*/
  function IS_HARD_WORD(P_WORD IN NVARCHAR2) RETURN VARCHAR2 IS
    FunctionResult varchar2(3) := 'N';
    V_TMP varchar2(600);
  BEGIN
    
    V_TMP := TO_CHAR(P_WORD);
    
    IF V_TMP <> P_WORD THEN
      FunctionResult := 'Y';
    END IF;
  
    RETURN (FunctionResult);
  END;

  /* 將 輸入文字 進行轉換 */
  function REPLACE_HARD_WORD(P_WORD IN NVARCHAR2) RETURN VARCHAR2 IS
    FunctionResult varchar2(200) := '';
  
    V_LEN number;
    V_NUM number;
  
    V_WORD nvarchar2(100);
    V_S    nvarchar2(2); --難字
    V_N    varchar2(10); --轉換字
  BEGIN
  
    V_LEN := LENGTH(P_WORD);
    IF V_LEN >= 1 THEN
    
      V_WORD := P_WORD;
    
      -- 跑過每個文字
      FOR V_NUM IN 1 .. V_LEN LOOP
      
        -- 查是否有在難字表中
        V_S := substr(V_WORD, V_NUM, 1);
        V_N := NULL;
      
        BEGIN
          SELECT W.NEW_WORD
            INTO V_N
			-- 自訂難字表
            FROM DVB_WORDS W
           WHERE W.OLD_WORD = V_S
             AND W.STATUS = 'Y';
        EXCEPTION
          WHEN OTHERS THEN
            V_N := NULL;
        END;
      
        -- 如果有找到難字
        IF V_N IS NOT NULL THEN
          V_WORD := REPLACE(V_WORD, V_S, V_N);
        END IF;
      
      END LOOP;
    
      -- 將 Nvarchar2 轉為 varchar2
      FunctionResult := TO_CHAR(V_WORD);
    
    END IF;
  
    RETURN(FunctionResult);
  
  END;

end PRO_HARD_WORD;
/
