create or replace function GET_CHI_WEEK(i_Date in Date,
                                        i_TYPE in varchar2 --回傳類型(1=中文；2=英文全名；3=英文簡寫)
                                        ) return varchar2 is
  FunctionResult varchar2(10);
  v_TMP_RESULT   varchar2(30);

  -- 全部的結果寫在一起，自己再用 substr 切出去
  FUNCTION GET_WEEK_DATA(i_DATE in date) return varchar2 is
    FunctionResult varchar2(30);
    v_WEEK         varchar(3);
  BEGIN
    --算星期幾
    --Sunday=1, Monday=2 ....
    SELECT TO_CHAR(i_Date, 'D') into v_WEEK FROM dual;
  
    -- 格式為：
    -- 1碼 中文
    -- 9碼 英文全部
    -- 3碼 英文縮寫
    --終共 13 碼 (拿的時候記得要 TRIM掉)
    CASE v_WEEK
      WHEN '1' THEN
        FunctionResult := '日Sunday   SUN';
      WHEN '2' THEN
        FunctionResult := '一Monday   MON';
      WHEN '3' THEN
        FunctionResult := '二Tuesday  TUE';
      WHEN '4' THEN
        FunctionResult := '三WednesdayWED';
      WHEN '5' THEN
        FunctionResult := '四Thursday THU';
      WHEN '6' THEN
        FunctionResult := '五Friday   FRI';
      WHEN '7' THEN
        FunctionResult := '六Saturday SAT';
      ELSE
        FunctionResult := '              ';
    END CASE;
  
    RETURN(FunctionResult);
  
  END GET_WEEK_DATA;

begin

  v_TMP_RESULT := GET_WEEK_DATA(i_Date);

  CASE i_TYPE
    WHEN '1' THEN
      -- 中文
      FunctionResult := TRIM(substr(v_TMP_RESULT, 1, 1));
    
    WHEN '2' THEN
      -- 英文 全名
      FunctionResult := TRIM(substr(v_TMP_RESULT, 2, 9));
    
    WHEN '3' THEN
      --英文縮寫
      FunctionResult := TRIM(substr(v_TMP_RESULT, 11, 3));
    
    ELSE
      -- 預設都是取中文
      FunctionResult := TRIM(substr(v_TMP_RESULT, 1, 1));
  END CASE;

  return(FunctionResult);
end GET_CHI_WEEK;
