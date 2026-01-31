-- 先宣告類型
CREATE OR REPLACE TYPE SPLIT_TEXT_TYPE IS TABLE OF VARCHAR2 (4000);

-- pipelined 有點像是 Table Function的概念(一樣要先建 Type， 呼叫時一樣是用 TABLE()來做)
create or replace function SPLIT(P_SOURCE VARCHAR2, P_SPLIT_STR VARCHAR2 DEFAULT ',')  RETURN SPLIT_TEXT_TYPE pipelined
 is
   V_INX  NUMBER;
   V_LEN  NUMBER;

   -- 切完後的字串
   V_CURRENT_STR VARCHAR2(2000) := P_SOURCE;

begin

    -- 抓出 分隔字串的長度
    V_LEN := LENGTH(P_SPLIT_STR);

   LOOP
      V_INX := INSTR(V_CURRENT_STR, P_SPLIT_STR);  --先抓出位置

      -- 若有抓到位置，放入 Pipe 並重切字串
      IF V_INX > 0 THEN
          pipe row(SUBSTR(V_CURRENT_STR, 1, V_INX - 1));  -- Pipe row (資料)
          V_CURRENT_STR := SUBSTR(V_CURRENT_STR, V_INX + V_LEN);  --重切字串(取到後面開始的值)
      ELSE
          -- 若沒有就剩下的全部輸出
          pipe row(V_CURRENT_STR);
          exit;  --離開Loop
      END IF;
   END LOOP;

   return;
end;
/


------------------------------------------------------------下面是使用方式------------------------------------------------
SELECT * FROM TABLE(SPLIT('A,B,C,D,E', ','));
