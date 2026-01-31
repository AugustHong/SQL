  select k.a
    from (select t.a
            from A t
           where t.b = 1
           order by t.c desc) k
   where rownum = 1;
