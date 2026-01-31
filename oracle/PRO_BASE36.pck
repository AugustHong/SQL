create or replace package PRO_BASE36 is

  -- Author  : HONG
  -- Created : 2021/11/18 下午 04:19:03
  -- Purpose : 36進制的轉換

  -- 36進制 轉 10 進制
  FUNCTION F_36TO10(P_SOURCE IN VARCHAR2) RETURN NUMBER;

  -- 10進制 轉 36進制
  FUNCTION F_10TO36(P_SOURCE IN NUMBER) RETURN VARCHAR2;

end PRO_BASE36;
/
create or replace package body PRO_BASE36 is

  -- 36進制 轉 10 進制
  FUNCTION F_36TO10(P_SOURCE IN VARCHAR2) RETURN NUMBER IS
    FunctionResult NUMBER := 0;
    V_STR36        varchar(36) := '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    V_subWork      varchar(1);
    V_workIndex    NUMBER;
    V_LEN          NUMBER;
    V_INDEX        NUMBER := 1;
    V_STR          VARCHAR2(400);
  
  BEGIN
  
    V_STR := UPPER(TRIM(P_SOURCE));
    V_LEN := LENGTH(V_STR);
  
    while V_INDEX <= V_LEN loop
      V_subWork := SUBSTR(V_STR, V_INDEX, 1); -- 取出單個字串
    
      -- 算他是第幾位，要 給他 36 的幾次方
      IF V_subWork = '0' THEN
        V_workIndex := 0;
      ELSE
        V_workIndex := INSTR(V_STR36, V_subWork, 1, 1);
      END IF;
    
      FunctionResult := FunctionResult +
                        (V_workIndex * power(36, V_LEN - V_INDEX));
      V_INDEX        := V_INDEX + 1;
    end loop;
  
    return FunctionResult;
  END;

  -- 10進制 轉 36進制
  FUNCTION F_10TO36(P_SOURCE IN NUMBER) RETURN VARCHAR2 IS
  
    FunctionResult VARCHAR2(100);
    v_new_data_m   number;
    v_new_data_d   number;
    v_original_num number := P_SOURCE;
    v_run          boolean := true;
  
  BEGIN
  
    v_run := true;
    while v_run loop
    
      /*取得分母與分子*/
      v_new_data_m := floor(v_original_num / 36);
      v_new_data_d := mod(v_original_num, 36);
    
      /*若分子 >= 10, 則轉換成 A
      串接前面資料*/
      if v_new_data_d < 10 then
        FunctionResult := v_new_data_d || FunctionResult;
      else
        FunctionResult := chr(v_new_data_d + 55) || FunctionResult;
      end if;
    
      /*若分母 = 0, 則表示轉換完成, 否則繼續轉換之*/
      if v_new_data_m = 0 then
        v_run := false;
      else
        v_original_num := v_new_data_m;
      end if;
    end loop;
  
    return(FunctionResult);
  
  END;

end PRO_BASE36;
/
