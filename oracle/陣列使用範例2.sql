-- 陣列使用範例2 (數字的)
  procedure test_number_array is
  
    -- 宣告數字陣列
    type seq_array is table of number index by BINARY_INTEGER;
  
    -- 使用數字陣列
    V_SEQ_INDEX  NUMBER;
    V_SEQ_ARRAY       seq_array;
    V_LAST_ID    NUMBER;
  
    CURSOR C1 IS
    SELECT * FROM TableA;
  
  begin
  
    V_SEQ_INDEX       := 1;
    V_SEQ_ARRAY.DELETE;  --先清空一次 (其實不一定要放這個)
  
    FORM ITEM in C1 LOOP
      V_SEQ_ARRAY(V_SEQ_INDEX) := ITEM.ID;
      V_SEQ_INDEX := V_SEQ_INDEX + 1;
    END LOOP;
  
    -- 因為上面多加1，所以這邊要減回來
    V_SEQ_INDEX := V_SEQ_INDEX - 1;
  
    -- 抓出最後一筆ID
    IF V_SEQ_INDEX > 0 THEN
      V_LAST_ID := V_SEQ_ARRAY(V_SEQ_INDEX);
    END IF;
  
  end;