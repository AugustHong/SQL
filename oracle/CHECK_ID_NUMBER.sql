create or replace function CHECK_ID_NUMBER(i_ID_NUMBER in varchar2, --身份證 or 外籍證
                                           i_TYPE      in varchar2 -- 0 = 全部(3個，其中一個過就過)； 1 = 驗身份證 ； 2 = 驗外籍證(2個，其中一個過就過)；3 = 舊外籍證；4 = 新外籍證
                                           ) return varchar2 is
                                           

  FunctionResult varchar2(2) := 'N'; -- 結果
  
  -- 將 A-Z 轉碼
  -- A = 10  順序為 ABCDEFGHJKLMNPQRSTUVXYWZIO
  -- O = 35
  FUNCTION GET_ID_ENG_TO_CODE(i_ENG in varchar2) RETURN number IS
    v_Result number := -1; -- 結果
    
    v_ENG varchar2(1);  --暫存值
    v_CODE_LIST varchar2(30) := 'ABCDEFGHJKLMNPQRSTUVXYWZIO';
    
  BEGIN
    
     IF i_ENG is not null THEN
       
             --先轉大寫，並取第一碼即可
             v_ENG := substr(Upper(i_ENG), 1, 1);
             
             -- 確定是 A-Z (65-90)
             IF ascii(v_ENG) between 65 and 90 THEN
               
                --找其 indexOf 再加 10 就是答案 (最後面的減1 是因為 第1位(A) 得到的是 1)
                v_Result := Instr(v_CODE_LIST, v_ENG, -1, 1) + 10 - 1;
               
             END IF;
       
     END IF;    
     
     RETURN(v_Result);
     
  END GET_ID_ENG_TO_CODE;
  
  --輸出 純數字字串 ，和 相對應的基數，相乘
  FUNCTION GET_TOTAL_BY_BASE(i_SOURCE in varchar2, --純數字字串
                             i_BASE in varchar2,  --基數組
                             i_IS_MOD in varchar2,  --是否要 Mod 10 的數來加 (外籍證號用)
                             o_ERROR out varchar2  --是否有錯誤
                            ) RETURN number IS
                            
       v_Result number := 0;  --結果
       v_loop_index number := 1; -- Loop Index  
       v_exist_loop varchar2(1) := 'N';  --是否要離開迴圈
       
       v_len number := 0;  --輸入的字串 和 基數 的長度   
       v_S varchar2(1);   --輸入字串字元
       v_B varchar2(1);   --基數組 字元  
       V_TMP number := 0; --暫存變數
  BEGIN
    
    o_ERROR := 'N';
  
     -- 輸入的字串 和 基數 的長度必需相同
     IF length(i_SOURCE) = length(i_BASE) THEN
       
       -- 將長度給值
       v_len := length(i_SOURCE);
       
        -- 將 後面的 2-10碼 全部 乘上基數
        while v_exist_loop = 'N' loop
               
                 -- 取出字串
                 v_S := substr(i_SOURCE, v_loop_index, 1);
                 v_B := substr(i_BASE, v_loop_index, 1);
                 
                 --確定是不是 數字 (0-9 => 48-57)
                 IF (ascii(v_S) between 48 and 57) AND (ascii(v_B) between 48 and 57) THEN
                   
                   
                   -- 加總 得到的數字 * 基數
                   V_TMP := to_number(v_S) * to_number(v_B);
                   
                   -- 判斷要不要 MOD
                   IF i_IS_MOD = 'Y' THEN
                     v_Result := v_Result + MOD(V_TMP, 10);
                   ELSE
                     
                      v_Result := v_Result + V_TMP;              
                   END IF;
                              
                                    
                   --index++
                   v_loop_index := v_loop_index + 1;
                   
                   --如果超過 長度 就跳出
                   IF v_loop_index > v_len THEN
                     v_exist_loop := 'Y'; --跳出
                   END IF;
                   
                 ELSE
                   v_Result := 0;  --因為有錯誤，所以輸出直接給 0
                   o_ERROR := 'Y';  --給出有錯誤
                   v_exist_loop := 'Y'; --跳出
                 END IF;
               
             END loop;
       
     ELSE
       o_ERROR := 'Y';
     END IF;
      
     RETURN (v_Result);
  
  END GET_TOTAL_BY_BASE;
  
  --驗身份證函式
  FUNCTION CHECK_ID(i_NO in varchar2) RETURN varchar2 IS
    v_Result varchar2(2) := 'N';
    v_NO varchar2(15);  --暫存身份證
    v_NO_1 varchar2(1);  --第一個字
    v_NO_2 varchar2(1);  --第二個字
    
    v_letterCode varchar2(3);  --第一個字母轉換出來的 (例如： A 得到 10)
    
    --處理完的數字組，例如： A123456789
    -- 這裡放的就是 10123456789
    v_handle_NO varchar2(15);
    v_data number := 0;  -- 字串 * 基數 的總和
    v_error varchar2(2) := 'N'; --是否有錯
  BEGIN
    
     --長度要為 10
     IF length(i_NO) = 10 THEN
       
        -- 先轉為大寫
        v_NO := Upper(i_NO);
        v_NO_1 := substr(v_NO, 1, 1);
        v_NO_2 := substr(v_NO, 2, 1);
        
        --首字是 A-Z (65-90)
        IF ascii(v_NO_1) between 65 and 90 THEN
          
           --第2碼 只能是 1 or 2
           IF v_NO_2 in ('1', '2') THEN
             
             --將 第一個字母 轉換 (A -> 10)
             v_letterCode := to_char(GET_ID_ENG_TO_CODE(v_NO_1));
             
             --組合字串 A123456789 => 10123456789
             v_handle_NO := v_letterCode || substr(v_NO, 2, 9);
             
             --叫用 字串 * 基數
             v_data := GET_TOTAL_BY_BASE(v_handle_NO, --輸入字串
                                      '19876543211', --基數組
                                      null,    --不要 MOD (乘起來是什麼就什麼)
                                      v_error  -- 是否有錯
                                     );
                                     
             --都沒有錯誤的話
             IF v_error = 'N' THEN
               IF MOD((v_data), 10) = 0 THEN
                  --是身份證
                  v_Result := 'Y';
               END IF;
             END IF;
             
           END IF;
          
        END IF;
       
     END IF;
  
     return v_Result;
  END CHECK_ID;

  
  --驗證 舊的 外籍證
  FUNCTION CHECK_OLD_FOREIGN_ID(i_NO in varchar2) RETURN varchar2 IS
    
    v_Result varchar2(2) := 'N';
    v_NO varchar2(15);  --暫存外籍證
    v_NO_1 varchar2(1);  --第一個字
    v_NO_2 varchar2(1);  --第二個字
    
    v_letterCode varchar2(3);  --第一個字母轉換出來的 (例如： A 得到 10)
    v_letterCode2 varchar2(3); -- 第一個字母轉換出來的 (例如： A 得到 10)
    
    --處理完的數字組，例如： AD23456789
    -- 這裡放的就是 10323456789
    v_handle_NO varchar2(15);
    v_data number := 0;  -- 字串 * 基數 的總和
    v_error varchar2(2) := 'N'; --是否有錯
    v_tmp varchar2(10);  --暫存變數
    
  BEGIN
    
     --長度要為 10
     IF length(i_NO) = 10 THEN
       
        -- 先轉為大寫
        v_NO := Upper(i_NO);
        v_NO_1 := substr(v_NO, 1, 1);
        v_NO_2 := substr(v_NO, 2, 1);
        
        --首字是 A-Z (65-90)
        IF ascii(v_NO_1) between 65 and 90 THEN
          
           --第2碼 只能是 A - D
           IF v_NO_2 in ('A', 'B', 'C', 'D') THEN
             
             --將 第一個字母 轉換 (A -> 10)
             v_letterCode := to_char(GET_ID_ENG_TO_CODE(v_NO_1));
             v_letterCode2 := to_char(GET_ID_ENG_TO_CODE(v_NO_2));
             
             --組合字串 AD23456789 => 10323456789
             -- 第一個 A 轉成的 10 直接用
             -- 第二碼 D 轉成的 13 拿 尾巴 3 (即是 mod 10 的值)
             -- 拿 7碼而已 (因為最後一碼是檢查碼)
             v_handle_NO := v_letterCode 
                             || to_char(MOD(to_number(v_letterCode2), 10))
                             || substr(v_NO, 3, 7);
             
             --叫用 字串 * 基數
             v_data := GET_TOTAL_BY_BASE(v_handle_NO, --輸入字串
                                      '1987654321', --基數組
                                      'Y',      --要 MOD
                                      v_error  -- 是否有錯
                                     );
                                     
             --都沒有錯誤的話
             IF v_error = 'N' THEN
              
              v_tmp := to_char(v_data);  --把結果 轉字串
              v_tmp := substr(v_tmp, length(v_tmp), 1); --拿取最後一碼
             
               -- 用 10 - 你得到的值 最後一碼 = 你 輸入的最後一碼
               IF 10 - to_number(v_tmp) = to_number(substr(v_NO, 10, 1)) THEN
                 v_Result := 'Y';
               END IF;
             END IF;
             
           END IF;
          
        END IF;
       
     END IF;
    
     RETURN(v_Result);
  
  END CHECK_OLD_FOREIGN_ID;


  --驗證 新的 外籍證
  FUNCTION CHECK_NEW_FOREIGN_ID(i_NO in varchar2) RETURN varchar2 IS
    
    v_Result varchar2(2) := 'N';
    v_NO varchar2(15);  --暫存外籍證
    v_NO_1 varchar2(1);  --第一個字
    v_NO_2 varchar2(1);  --第二個字
    
    v_letterCode varchar2(3);  --第一個字母轉換出來的 (例如： A 得到 10)
    
    --處理完的數字組，例如： A800000014
    -- 這裡放的就是 10800000014
    v_handle_NO varchar2(15);
    v_data number := 0;  -- 字串 * 基數 的總和
    v_error varchar2(2) := 'N'; --是否有錯
    v_tmp varchar2(10);  --暫存變數
    
  BEGIN
    
     --長度要為 10
     IF length(i_NO) = 10 THEN
       
        -- 先轉為大寫
        v_NO := Upper(i_NO);
        v_NO_1 := substr(v_NO, 1, 1);
        v_NO_2 := substr(v_NO, 2, 1);
        
        --首字是 A-Z (65-90)
        IF ascii(v_NO_1) between 65 and 90 THEN
          
           --第2碼 只能是 8 or 9
           IF v_NO_2 in ('8', '9') THEN
             
             --將 第一個字母 轉換 (A -> 10)
             v_letterCode := to_char(GET_ID_ENG_TO_CODE(v_NO_1));
             
             --組合字串 A800000014 => 10800000014
             -- 第一個 A 轉成的 10 直接用
             -- 拿後面的 8碼，最後一碼是檢查碼
             v_handle_NO := v_letterCode 
                             || substr(v_NO, 2, 8);
             
             --叫用 字串 * 基數
             v_data := GET_TOTAL_BY_BASE(v_handle_NO, --輸入字串
                                      '1987654321', --基數組
                                      'Y',      --要 MOD
                                      v_error  -- 是否有錯
                                     );
                                     
             --都沒有錯誤的話
             IF v_error = 'N' THEN
              
              v_tmp := to_char(v_data);  --把結果 轉字串
              v_tmp := substr(v_tmp, length(v_tmp), 1); --拿取最後一碼
             
               -- 用 10 - 你得到的值 最後一碼 = 你 輸入的最後一碼
               IF 10 - to_number(v_tmp) = to_number(substr(v_NO, 10, 1)) THEN
                 v_Result := 'Y';
               END IF;
             END IF;
             
           END IF;
          
        END IF;
       
     END IF;
    
     RETURN(v_Result);
  
  END CHECK_NEW_FOREIGN_ID;

  
begin
  
   --依照類型
   IF i_TYPE = '0' THEN
      --全部都驗 (但其中一個過就過)
      IF CHECK_ID(i_ID_NUMBER) = 'Y' or
           CHECK_OLD_FOREIGN_ID(i_ID_NUMBER) = 'Y' or
           CHECK_NEW_FOREIGN_ID(i_ID_NUMBER) = 'Y' THEN
           
           FunctionResult := 'Y';
      ELSE
           FunctionResult := 'N';
      END IF;
      
   ELSIF i_TYPE = '1' THEN
       --只驗身份證
       FunctionResult := CHECK_ID(i_ID_NUMBER);
      
   ELSIF i_TYPE = '2' THEN
       --驗 舊 + 新 外籍證 (但其中一個過就過)
       IF CHECK_OLD_FOREIGN_ID(i_ID_NUMBER) = 'Y' or
           CHECK_NEW_FOREIGN_ID(i_ID_NUMBER) = 'Y' THEN
           
           FunctionResult := 'Y';
      ELSE
           FunctionResult := 'N';
      END IF;
      
   ELSIF i_TYPE = '3' THEN
       -- 舊式 外籍證
       FunctionResult := CHECK_OLD_FOREIGN_ID(i_ID_NUMBER);
       
   ELSIF i_TYPE = '4' THEN
       -- 新式 外籍證
       FunctionResult := CHECK_NEW_FOREIGN_ID(i_ID_NUMBER);  

   ELSE
       -- 預設 都驗 身份證
       FunctionResult := CHECK_ID(i_ID_NUMBER);
   END IF;

  return(FunctionResult);
end CHECK_ID_NUMBER;
