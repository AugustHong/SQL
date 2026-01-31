SELECT CASE
        WHEN 1 = 1 THEN 'Y'
        WHEN 1 = 2 THEN 'N'
        ELSE ''
      END AS T
FROM DUAL;  -- CASE WHEN (在 SP 和 Function 會再長一點不同)

------------------------------------------------------------------------

-- 在 SP 和 Function 會是
CASE 欄位
        WHEN 'A' THEN 'Y'
        WHEN 'B' THEN 'N'
        ELSE ''
      END CASE;
    