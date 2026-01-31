SELECT INSTR('ABC', 'B', 1) FROM DUAL;  --查 B 在 ABC 的第幾位 (1 從 1 開始)，第3碼是指從第幾位開始找(預設1，所以可不填，一樣1從1開始)

SELECT INSTR('123', CHR(10)), INSTR('123', CHR(13) || CHR(10)) FROM DUAL;  --CHR(10) = \n   CHR(13) || CHR(10)=\r\n