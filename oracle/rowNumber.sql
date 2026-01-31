SELECT row_number() over(partition by C1 order by ID desc) rowNumber,
                                   ID,
                                   C1
                              FROM TableA  -- 用 C1相同的來當作條件，再用 ID來排序到得 數字